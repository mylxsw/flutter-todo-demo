enum TodoStatus { active, completed }

class Todo {
  int id;
  String title;
  String description;
  TodoStatus status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Todo({
    this.id = 0,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.status = TodoStatus.active,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id > 0 ? id : null,
      'title': title,
      'description': description,
      'status': status.name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
