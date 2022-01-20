import 'package:progress_app/models/user.dart';

class ProjectMember {
  int id;
  String? email;
  String? inviteToken;
  bool isAdmin;
  String? validatedAt;
  String createdAt;
  String updatedAt;
  User? user;

  ProjectMember({
    required this.id,
    this.email,
    required this.isAdmin,
    this.validatedAt,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory ProjectMember.fromJson(Map<String, dynamic> json) {
    return ProjectMember(
      id: json['id'] as int,
      email: json['email'] as String,
      isAdmin: json['is_admin'] as bool,
      validatedAt: json['validated_at'],
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,

      user: json['user'] != null ? User.fromJson(json) : null,
    );
  }
}