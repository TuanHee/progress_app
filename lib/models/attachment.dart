
class Attachment {
  int id;
  int taskId;
  String? name;
  String link;
  String type;
  String createdAt;
  String updatedAt;

  Attachment({
    required this.id,
    required this.taskId,
    this.name,
    required this.link,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      taskId: json['task_id'],
      name: json['name'],
      link: json['link'],
      type: json['type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}