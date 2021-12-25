import 'package:progress_app/models/task_list.dart';
import 'package:progress_app/models/user.dart';

class Project {
  final int id;
  final bool? inviteLinkStatus;
  final String title;
  final String? description, inviteLinkToken;
  final String createdAt;
  final String updatedAt;
  User? author;
  List<TaskList>? taskList;
  List<User> member = [];

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
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id : json['id'] as int,
      title : json['title'] as String,
      description : json['description'],
      createdAt : json['created_at'],
      updatedAt : json['updated_at'],
      inviteLinkToken : json['invite_link_token'],
      inviteLinkStatus : json['invite_link_status'] ?? false
    );
  }

  // Map<String, dynamic> toJson() => {
  //   'id' : id,
  //   'title' : title,
  //   'description' : description,
  // };
}
