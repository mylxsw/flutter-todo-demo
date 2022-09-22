enum TodoStatus { active, completed }

class Todo {
  String id;
  String title;
  String description;
  TodoStatus status = TodoStatus.active;
  DateTime createdAt;
  DateTime? updatedAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });
}
