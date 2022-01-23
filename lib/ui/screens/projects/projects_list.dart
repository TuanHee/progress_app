import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/models/project.dart';
import 'package:progress_app/services/network.dart';
import 'package:progress_app/shared/side_menu.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({ Key? key }) : super(key: key);

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        elevation: 1,
      ),
      drawer: const SideMenu(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.pushNamed(context, '/projects/create'),
      ),
      body: FutureBuilder<List<Project>>(
        future: fetchProjects(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("An error has occurred!"),
            );
          } else if (snapshot.hasData) {
            return ProjectsList(projects: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }

  List<Project> parseProjects (String responseBody) {
    var parsed = convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Project>((json) => Project.fromJson(json)).toList();
  }

  Future<List<Project>> fetchProjects() async {
    final response = await NetworkService().getRequest('/projects');
    // Use the compute function to run parsePhotos in a separate isolate.
    return parseProjects(response.body);
  }
}

class ProjectsList extends StatelessWidget {
  const ProjectsList({ Key? key, required this.projects }) : super(key: key);

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * .5),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return ProjectItem(project: projects[index]);
      },
    );
  }
}

class ProjectItem extends StatelessWidget {
  const ProjectItem({ Key? key, required this.project }) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding * .5,
          vertical: kDefaultPadding * .2
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding * .5, 
            vertical: kDefaultPadding * .5
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 10),
                blurRadius: 30,
                color: kPrimaryColor.withOpacity(0.1)
              ),
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                project.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: kDefaultPadding * .3),
              Text(
                project.createdAt,
              ),
            ],
          ),
        ),
      ),onTap: () => Navigator.pushNamed(context, '/projects/detail', arguments: project),
      
    );
  }
}