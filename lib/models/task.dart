import 'package:progress_app/models/attachment.dart';
import 'package:progress_app/models/comment.dart';
import 'package:progress_app/models/user.dart';

class Task {
  int id;
  String title;
  String assignedAt;
  String updatedAt;
  // ProjectMember author;
  List<Task>? tasks;
  List<User>? member;
  List<Attachment>? attachments;
  List<Comment>? comments;

  Task({
    required this.id,
    required this.title,
    required this.assignedAt,
    required this.updatedAt,
    // required this.author,
    this.member,
    this.tasks,
    this.attachments,
    this.comments,
  });
  
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id : json['id'] as int,
      title : json['title'] as String,
      assignedAt : json['assigned_at'] as String,
      updatedAt : json['updated_at'] as String,
      // author: ProjectMember.fromJson(json['member']),
    );
  }
}