import 'dart:convert' as convert;
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progress_app/services/apis_service.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/models/task_list.dart';
import 'package:progress_app/models/task.dart';
import 'package:progress_app/services/network.dart';
import 'package:progress_app/shared/input_field.dart';
import 'package:progress_app/shared/title_with_more_btn.dart';

class ProjectTaskListPage extends StatefulWidget {
  const ProjectTaskListPage({Key? key, required this.projectId})
      : super(key: key);

  final int projectId;

  @override
  _ProjectTaskListPageState createState() => _ProjectTaskListPageState();
}

class _ProjectTaskListPageState extends State<ProjectTaskListPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    TextEditingController taskListTitleController = TextEditingController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding * .5, horizontal: kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TitleWithCustomUnderline(title: 'Task'),
              MaterialButton(
                  elevation: 0,
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0))),
                        context: context,
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: Padding(
                              padding: const EdgeInsets.all(kDefaultPadding),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Add Task List",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  InputField("Task List Title",
                                      taskListTitleController),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      MaterialButton(
                                          color: Colors.grey.shade100,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Close')),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      MaterialButton(
                                          color: kPrimaryColor,
                                          textColor: Colors.white,
                                          onPressed: () async {
                                            String title =
                                                taskListTitleController.text
                                                    .trim();

                                            if (title.isEmpty) {
                                              Navigator.pop(context);
                                              const snackBar = SnackBar(
                                                elevation: 6.0,
                                                backgroundColor: dangerBgColor,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                content: Text(
                                                    'Title fields are required!'),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            } else {
                                              var res = await NetworkService()
                                                  .postRequest(
                                                      '/projects/${widget.projectId}/taskLists',
                                                      data: {
                                                        "title": title,
                                                      },
                                                      withAuth: true);

                                              if (res.statusCode == 200) {
                                                setState(() {
                                                  fetchTaskLists();
                                                });
                                                Navigator.pop(context);
                                              } else {
                                                inspect(res);
                                              }
                                            }
                                          },
                                          child: const Text('Add'))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  })
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<TaskList>>(
            future: fetchTaskLists(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("An error has occurred!"),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return TaskListListWidget(
                    taskLists: snapshot.data!,
                    size: size,
                    updateTaskList: () => setState(() {
                          fetchTaskLists();
                        }));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        )
      ],
    );
  }

  List<TaskList> parseTaskLists(String responseBody) {
    var parsed = convert
        .jsonDecode(responseBody)['task_lists']
        .cast<Map<String, dynamic>>();

    return parsed.map<TaskList>((json) => TaskList.fromJson(json)).toList();
  }

  Future<List<TaskList>> fetchTaskLists() async {
    final response =
        await NetworkService().getRequest('/projects/${widget.projectId}');
    // Use the compute function to run parsePhotos in a separate isolate.
    return parseTaskLists(response.body);
  }
}

class TaskListListWidget extends StatelessWidget {
  const TaskListListWidget({
    Key? key,
    required this.size,
    required this.taskLists,
    required this.updateTaskList,
  }) : super(key: key);

  final Size size;
  final List<TaskList> taskLists;
  final VoidCallback updateTaskList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      scrollDirection: Axis.horizontal,
      itemCount: taskLists.length,
      itemBuilder: (context, index) {
        return _TaskListItem(
            size: size,
            taskList: taskLists[index],
            updateTaskList: updateTaskList);
      },
      separatorBuilder: (_, index) => const SizedBox(width: 20),
    );
  }
}

class _TaskListItem extends StatefulWidget {
  const _TaskListItem({
    Key? key,
    required this.size,
    required this.taskList,
    required this.updateTaskList,
  }) : super(key: key);

  final Size size;
  final TaskList taskList;
  final VoidCallback updateTaskList;

  @override
  State<_TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<_TaskListItem> {
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.taskList.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding * .5,
          ),
          width: (widget.size.width * .95) - 40,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(3, 5),
                    blurRadius: 10,
                    color: kPrimaryColor.withOpacity(0.15))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.taskList.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              ButtonBar(
                overflowButtonSpacing: 0,
                children: [
                  MaterialButton(
                    onPressed: () {},
                    minWidth: 12,
                    child: const Icon(Icons.add),
                  ),
                  MaterialButton(
                    onPressed: () => showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0))),
                        context: context,
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        builder: (context) {
                          return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: Padding(
                                padding: const EdgeInsets.all(kDefaultPadding),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Edit Task List",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    InputField(
                                        "Task List Title", titleController),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        MaterialButton(
                                            color: Colors.grey.shade100,
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Close')),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        MaterialButton(
                                            color: kPrimaryColor,
                                            textColor: Colors.white,
                                            onPressed: () async {
                                              String title =
                                                  titleController.text.trim();

                                              if (title.isEmpty) {
                                                Navigator.pop(context);
                                                titleController.text = widget.taskList.title;
                                                const snackBar = SnackBar(
                                                  elevation: 6.0,
                                                  backgroundColor:
                                                      dangerBgColor,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text(
                                                      'Title fields are required!'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else {
                                                var res = await NetworkService()
                                                    .putRequest(
                                                  "/taskLists/${widget.taskList.id}",
                                                  data: {
                                                    "title": title,
                                                  },
                                                );

                                                if (res.statusCode == 200) {
                                                  setState(() {
                                                    widget.updateTaskList();
                                                  });
                                                  Navigator.pop(context);
                                                } else {
                                                  inspect(res);
                                                }
                                              }
                                            },
                                            child: const Text('Update'))
                                      ],
                                    ),
                                  ],
                                ),
                              ));
                        }),
                    minWidth: 12,
                    child: const Icon(Icons.edit),
                  ),
                  if (widget.taskList.tasks!.isEmpty)
                    MaterialButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Row(
                                  children: const [
                                    Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 10),
                                    Text('Delete Task List'),
                                  ],
                                ),
                                content: const Text(
                                    'Are you sure you want to delete the task list? This action cannot be undone.',
                                    textAlign: TextAlign.justify),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('CANCEL')),
                                  TextButton(
                                      onPressed: () async {
                                        var res = await NetworkService()
                                            .deleteRequest(
                                                '/taskLists/${widget.taskList.id}');

                                        if (res.statusCode == 200) {
                                          Navigator.pop(context);
                                          widget.updateTaskList();
                                        } else if (res.statusCode == 202) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text('Error!')));
                                        } else if (res.statusCode == 404) {
                                          Navigator.pop(context);
                                          widget.updateTaskList();
                                        }
                                      },
                                      child: const Text(
                                        'DELETE',
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                      ))
                                ],
                              )),
                      minWidth: 12,
                      child: const Icon(Icons.delete),
                    ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 500,
          width: (widget.size.width * .95) - 40,
          child: widget.taskList.tasks!.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.only(bottom: kDefaultPadding * .3),
                  itemCount: widget.taskList.tasks!.length,
                  itemBuilder: (context, tasksIndex) {
                    return TaskWidget(
                      size: widget.size,
                      task: widget.taskList.tasks![tasksIndex],
                    );
                  },
                )
              : const Padding(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Text(
                    'Not Task Yet',
                    textAlign: TextAlign.center,
                  ),
                ),
        )
      ],
    );
  }
}

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key, required this.size, required this.task})
      : super(key: key);

  final Size size;
  final Task task;

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: widget.size.width - 40,
        margin: const EdgeInsets.fromLTRB(0, kDefaultPadding * .3, 0, 0),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              offset: const Offset(0, 5),
              blurRadius: 10,
              color: kPrimaryColor.withOpacity(.15))
        ]),
        child: Row(
          children: [
            Checkbox(
              value: widget.task.completed,
              onChanged: (bool? value) {
                setState(() {
                  widget.task.completed = value!;
                });
              },
            ),
            Text(widget.task.title),
          ],
        ),
      ),
      onTap: () {
        apiService.getTask((Task task) {
          Navigator.pushNamed(context, '/projects/task', arguments: task);
        }, (Response response) {}, widget.task.id);
      },
    );
  }
}
