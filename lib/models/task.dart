import 'package:progress_app/models/attachment.dart';
import 'package:progress_app/models/comment.dart';
import 'package:progress_app/models/user.dart';

class Task {
  int id;
  String title;
  String? description;
  String priority;
  bool completed;
  String? startAt;
  String? dueAt;
  String? rememberAt;
  String assignedAt;
  String updatedAt;
  // User author;
  List<Task>? tasks;
  List<User>? member;
  List<Attachment>? attachments;
  List<Comment>? comments;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    this.startAt,
    this.dueAt,
    this.rememberAt,
    required this.assignedAt,
    required this.updatedAt,
    // required this.author,
    required this.completed,
    this.member,
    this.tasks,
    this.attachments,
    this.comments,
  });
  
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id : json['id'] as int,
      title : json['title'] as String,
      description: json['description'] == null ? json['description'] as String? : null,
      priority: json['priority'] as String,
      assignedAt : json['assigned_at'] as String,
      updatedAt : json['updated_at'] as String,
      completed: json['completed'] as bool,
    );
  }
}
