import 'dart:convert' as convert;
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:progress_app/models/project_member.dart';
import 'package:progress_app/models/user.dart';
import 'package:progress_app/services/network.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/shared/title_with_more_btn.dart';

class ProjectMemberPage extends StatefulWidget {
  const ProjectMemberPage({Key? key, required this.projectId})
      : super(key: key);

  final int projectId;

  @override
  _ProjectMemberPageState createState() => _ProjectMemberPageState();
}

class _ProjectMemberPageState extends State<ProjectMemberPage> {
  Future<User> fetchProjectAuthor() async {
    final response = await NetworkService()
        .getRequest('/projects/${widget.projectId}/author');
    return User.fromJson(convert.jsonDecode(response.body)['user']);
  }

  Future<List<ProjectMember>> fetchProjectMembers() async {
    final response = await NetworkService()
        .getRequest('/projects/${widget.projectId}/members');
    var parsed = convert
        .jsonDecode(response.body)['members']
        .cast<Map<String, dynamic>>();
    inspect(parsed);
    return parsed.map<ProjectMember>((json) => ProjectMember.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            children: const [
              TitleWithCustomUnderline(title: "Project Author"),
            ],
          ),
        ),
        FutureBuilder<User>(
          future: fetchProjectAuthor(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("An error has occurred!"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return ProjectAuthorItem(user: snapshot.data!);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            children: const [
              TitleWithCustomUnderline(title: "Project Members"),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<ProjectMember>>(
            future: fetchProjectMembers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("An error has occurred!"),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return ListView.separated(
                  itemBuilder: (_, index) {
                    return ProjectMemberItem(member: snapshot.data![index]);
                  },
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (_, index) =>
                      const SizedBox(height: kDefaultPadding * .5),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}

class ProjectAuthorItem extends StatelessWidget {
  const ProjectAuthorItem({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding * .5),
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, 1),
            blurRadius: 10,
            color: Colors.grey.withOpacity(0.2)
          )
        ],
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              user.profileUrl,
              width: 45,
              height: 45,
            )
          ),
          const SizedBox(width: 20),
          Text(user.name),
        ],
      )
    );
  }
}


class ProjectMemberItem extends StatelessWidget {
  const ProjectMemberItem({
    Key? key,
    required this.member,
  }) : super(key: key);

  final ProjectMember member;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding * .5),
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, 1),
            blurRadius: 10,
            color: Colors.grey.withOpacity(0.2)
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.network(
              member.user!.profileUrl,
              width: 45,
              height: 45,
            )
          ),
          const SizedBox(width: 20),
          Text(member.user!.name),
          const SizedBox(width: 10),
          if (member.isAdmin)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Text(
                'Admin',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          if (member.validatedAt == null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: const BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Text(
                'Invited',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
        ],
      )
    );
  }
}
