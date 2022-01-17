
import 'package:progress_app/models/project_member.dart';

class Comment{
  int id;
  ProjectMember member;
  String content;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  Comment({
    required this.id,
    required this.member,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      member: ProjectMember.fromJson(json['member']),
      content: json['content'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      deletedAt: json['deleted_at'] as String?,
    );
  }
}