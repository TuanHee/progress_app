import 'package:flutter/material.dart';
import 'package:progress_app/models/project.dart';
import 'package:progress_app/shared/constants.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    Key? key,
    required this.size,
    required this.project,
  }) : super(key: key);

  final Size size;
  final Project project;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width / 2,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/projects/detail',
            arguments: project),
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(1, 1),
                  blurRadius: 10,
                  color: Colors.grey.withOpacity(0.3))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                project.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kDefaultPadding * .5),
                child: Row(
                  children: [
                    const Icon(Icons.list_alt_outlined,
                        color: Colors.black54, size: 20),
                    const SizedBox(width: 3),
                    if (project.tasksCompletedCount != 0 &&
                        project.tasksCount != 0)
                      Text(
                          "${project.tasksCompletedCount}/${project.tasksCount}")
                    else
                      const Text("-"),
                    const Spacer(),
                    const Icon(
                      Icons.people_alt_outlined,
                      color: Colors.black54,
                      size: 20,
                    ),
                    const SizedBox(width: 3),
                    for (var member in project.members!.take(3))
                      ClipOval(
                        child: Image.network(
                          member.profileUrl,
                          errorBuilder: (_, obj, stackTrace) {
                            return const Icon(Icons.error);
                          },
                          width: 20,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kDefaultPadding * 0.5),
                child: Text(
                  project.createdAt,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
