import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:progress_app/models/project.dart';
import 'package:progress_app/services/network.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/shared/project_card.dart';
import 'package:progress_app/shared/title_with_more_btn.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  Future<List<Project>> fetchRecentProjects() async {
    final response = await NetworkService().getRequest('/projects/recent');
    // Use the compute function to run parsePhotos in a separate isolate.
    return parseProjects(response.body);
  }

  List<Project> parseProjects(String responseBody) {
    var parsed = convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Project>((json) => Project.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        const SizedBox(height: kDefaultPadding),
        TitleWithMoreBtn(
            title: "Projects",
            press: () => Navigator.pushNamed(context, '/projects')),
        Container(
          height: 125,
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
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            children: [
              TitleWithCustomUnderline(title: "Assigned To You"),
            ],
          ),
        ),
      ],
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
      padding: EdgeInsets.symmetric(
          vertical: kDefaultPadding * .5, horizontal: kDefaultPadding),
      itemCount: projects.length,
      itemBuilder: (_, index) {
        return ProjectCard(project: projects[index], size: size);
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(width: 20);
      },
    );
  }
}
