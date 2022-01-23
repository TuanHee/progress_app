import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progress_app/models/project.dart';
import 'package:progress_app/models/task.dart';
import 'package:progress_app/services/network.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/shared/project_card.dart';
import 'package:progress_app/shared/title_with_more_btn.dart';
import 'package:progress_app/shared/side_menu.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:progress_app/services/apis_service.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  Future<List<Project>> fetchRecentProjects() async {
    final response = await NetworkService().getRequest('/projects/recent');
    // Use the compute function to run parsePhotos in a separate isolate.
    fetchTasksAssingedToMe();
    return parseProjects(response.body);
  }

  List<Project> parseProjects(String responseBody) {
    var parsed = convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Project>((json) => Project.fromJson(json)).toList();
  }

  Future<List<DueTask>> fetchTasksAssingedToMe() async {
    final response = await NetworkService().getRequest('/tasks/assignedToMe');

    var parsed = convert.jsonDecode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<DueTask>((json) => DueTask.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DraggableHome(
      alwaysShowLeadingAndAction: true,
      title: const Text('Dashboard'),
      backgroundColor: Colors.white,
      headerExpandedHeight: 0.32,
      headerWidget: Container(
        decoration: BoxDecoration(
          color: Colors.blue[50],
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            TitleWithMoreBtn(
                title: "Recent",
                press: () => Navigator.pushNamed(context, '/projects')),
            SizedBox(
              height: 135,
              child: FutureBuilder<List<Project>>(
                  future: fetchRecentProjects(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("An error has occurred!"),
                      );
                    } else if (snapshot.hasData) {
                      return RecentProjectsList(
                          size: size, projects: snapshot.data!);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
      drawer: const SideMenu(),
      body: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            children: const [
              TitleWithCustomUnderline(title: "Assigned To You"),
            ],
          ),
        ),
        FutureBuilder<List<DueTask>>(
          future: fetchTasksAssingedToMe(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("An error has occurred!"),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return SizedBox(
                    height: size.height * .5,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue[50],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.task_alt,
                              size: 90, color: Colors.blue.shade600),
                          const SizedBox(height: 30),
                          Text(
                            'There are no tasks assigned to you right now.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15, color: Colors.blue.shade900, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ));
              }
              return TasksAssingedToMe(tasks: snapshot.data!);
            } else {
              return SizedBox(
                height: size.height * .6,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        )
      ],
    );
  }
}

class TasksAssingedToMe extends StatelessWidget {
  const TasksAssingedToMe({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  final List<DueTask> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () {
            apiService.getTask((Task task) {
              Navigator.pushNamed(context, '/projects/task', arguments: task);
            }, (Response response) {}, tasks[index].id);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding * .5,
                vertical: kDefaultPadding * .75),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(1, 1),
                      blurRadius: 10,
                      color: Colors.grey.withOpacity(0.3))
                ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${tasks[index].title} (${tasks[index].dueAt})'),
                const SizedBox(
                  width: 10,
                ),
                if (tasks[index].due)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Text(
                      'Due',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, index) =>
          const SizedBox(height: kDefaultPadding * .5),
    );
  }
}

class RecentProjectsList extends StatelessWidget {
  const RecentProjectsList(
      {Key? key, required this.size, required this.projects})
      : super(key: key);

  final Size size;
  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding * .5, horizontal: kDefaultPadding),
      itemCount: projects.length,
      itemBuilder: (_, index) {
        return ProjectCard(project: projects[index], size: size);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: kDefaultPadding * .5);
      },
    );
  }
}
