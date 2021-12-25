
class Comment{
  int id;
  int memberId;
  int taskId;
  String content;
  String createdAt;
  String updatedAt;
  String deletedAt;

  Comment({
    required this.id,
    required this.memberId,
    required this.taskId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt
  });
}