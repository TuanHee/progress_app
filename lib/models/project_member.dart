import 'package:progress_app/models/user.dart';

class ProjectMember {
  int id;
  User user;
  String? email;
  String? inviteToken;
  bool isAdmin;
  String? validatedAt;
  String createdAt;
  String updatedAt;

  ProjectMember({
    required this.id,
    required this.user,
    required this.isAdmin,
    this.validatedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectMember.fromJson(Map<String, dynamic> json) {
    return ProjectMember(
      id: json['id'] as int,
      user: User.fromJson(json['user']),
      isAdmin: json['is_admin'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}