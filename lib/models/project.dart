import 'package:progress_app/models/task_list.dart';
import 'package:progress_app/models/user.dart';

class Project {
  int id;
  bool? inviteLinkStatus;
  String title;
  String? description, inviteLinkToken;
  String createdAt;
  String updatedAt;
  User? author;
  List<TaskList>? taskList;
  List<User>? members;

  // count
  int? tasksCount;
  int? tasksCompletedCount;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.inviteLinkToken,
    this.author,
    this.inviteLinkStatus = false,
    this.taskList,
    this.tasksCount,
    this.tasksCompletedCount,
    this.members,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      inviteLinkToken: json['invite_link_token'],
      inviteLinkStatus: json['invite_link_status'] ?? false,
      
      tasksCount: json['tasks_count'],
      tasksCompletedCount: json['tasks_completed_count'],

      members: json['members'] != null
          ? json['members']
              .map<User>((member) => User.fromJson(member))
              .toList()
          : List.empty(),
    );
  }

  // Map<String, dynamic> toJson() => {
  //   'id' : id,
  //   'title' : title,
  //   'description' : description,
  // };
}
