import 'package:progress_app/models/task.dart';

class TaskList {
  int id;
  int projectId;
  String title;
  String? description;
  String createdAt;
  String updatedAt;
  List<Task>? tasks;
  
  TaskList({
    required this.id,
    required this.projectId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.tasks,
  });

  factory TaskList.fromJson(Map<String, dynamic> json) {

    if (json['tasks'] == null) {
      return TaskList(
        id: json['id'] as int,
        projectId: json['project_id'] as int,
        title: json['title'] as String,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
      );
    }

    return TaskList(
      id : json['id'] as int,
      projectId : json['project_id'] as int,
      title : json['title'] as String,
      createdAt : json['created_at'] as String,
      updatedAt : json['updated_at'] as String,
      tasks: (json['tasks'] as List).map<Task>((json) => Task.fromJson(json)).toList(),
    );
  }
}