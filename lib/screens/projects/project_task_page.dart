import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/models/task_list.dart';
import 'package:progress_app/models/task.dart';
import 'package:progress_app/services/network.dart';
import 'package:progress_app/shared/title_with_more_btn.dart';

class ProjectTaskListPage extends StatefulWidget {
  const ProjectTaskListPage({Key? key, required this.projectId}) : super(key: key);

  final int projectId;

  @override
  _ProjectTaskListPageState createState() => _ProjectTaskListPageState();
}

class _ProjectTaskListPageState extends State<ProjectTaskListPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * .5, horizontal: kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleWithCustomUnderline(title: 'Task'),
              MaterialButton(
                elevation: 0,
                color: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {}
              )
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
                return TaskListWidget(taskLists: snapshot.data!, size: size);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        )
      ],
    );
  }

  List<TaskList> parseTaskLists (String responseBody) {
    var parsed = convert.jsonDecode(responseBody)['task_lists'].cast<Map<String, dynamic>>();

    return parsed.map<TaskList>((json) => TaskList.fromJson(json)).toList();
  }

  Future<List<TaskList>> fetchTaskLists() async {
    final response = await NetworkService().getRequest('/projects/${widget.projectId}');
    // Use the compute function to run parsePhotos in a separate isolate.
    return parseTaskLists(response.body);
  }
}

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    Key? key,
    required this.size,
    required this.taskLists,
  }) : super(key: key);

  final Size size;
  final List<TaskList> taskLists;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: taskLists.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * .5,
                ),
                width: size.width - 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.only(topRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(3, 5),
                      blurRadius: 10,
                      color: kPrimaryColor.withOpacity(0.15)
                    )
                  ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      taskLists[index].title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    ButtonBar(
                      overflowButtonSpacing: 2,
                      children: [
                        MaterialButton(
                          onPressed: () {},
                          minWidth: 12,
                          child: Icon(Icons.add),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          minWidth: 12,
                          child: Icon(Icons.edit),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          minWidth: 12,
                          child: Icon(Icons.delete),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 500,
                width: size.width - 40,
                child: taskLists[index].tasks!.isNotEmpty ? ListView.builder(
                  padding: EdgeInsets.only(bottom: kDefaultPadding * .3),
                  itemCount: taskLists[index].tasks!.length,
                  itemBuilder: (context, tasksIndex) {
                    return TaskWidget(
                      size: size, 
                      task: taskLists[index].tasks![tasksIndex],
                    );
                  },
                ) : Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Text(
                    'Not Task Yet',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class TaskWidget extends StatefulWidget {
  const TaskWidget({ Key? key, required this.size, required this.task }) : super(key: key);

  final Size size;
  final Task task;

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width - 40,
      margin: EdgeInsets.fromLTRB(0, kDefaultPadding * .3, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            blurRadius: 10,
            color: kPrimaryColor.withOpacity(.15)
          )
        ]
      ),
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
    );
  }
}
