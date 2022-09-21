class Todo {
  String id;
  String title;
  String description;
  DateTime createdAt;
  DateTime? updatedAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });
}
