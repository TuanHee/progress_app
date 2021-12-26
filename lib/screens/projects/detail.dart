import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/models/project.dart';
import 'package:progress_app/screens/projects/project_information_page.dart';
import 'package:progress_app/screens/projects/project_member_page.dart';
import 'package:progress_app/screens/projects/project_task_page.dart';

class ProjectDetail extends StatefulWidget {
  const ProjectDetail({Key? key}) : super(key: key);

  @override
  _ProjectDetailState createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  @override
  Widget build(BuildContext context) {
    final Project project =
        ModalRoute.of(context)!.settings.arguments as Project;

    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: kPrimaryColor,
          title: Text(project.title),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: kPrimaryColor,
            unselectedLabelColor: Colors.grey[600],
            labelColor: Colors.grey[900],
            tabs: const [
              Tab(
                icon: Icon(Icons.list_alt_rounded),
                text: 'Information',
              ),
              Tab(
                icon: Icon(Icons.check_box_outlined),
                text: 'Tasks',
              ),
              Tab(
                icon: Icon(Icons.group_outlined),
                text: 'Members',
              )
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ProjectInformationPage(project: project),
            ProjectTaskListPage(projectId: project.id),
            ProjectMemberPage(projectId: project.id),
          ],
        ),
      ),
    );
  }
}
