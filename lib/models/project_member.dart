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
}