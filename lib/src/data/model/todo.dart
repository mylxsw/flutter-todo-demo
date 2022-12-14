import 'catalog.dart';

enum TodoStatus { active, completed }

class Todo {
  int id;
  String title;
  String description;
  TodoStatus status;
  Catalog? catalog;
  DateTime? createdAt;
  DateTime? updatedAt;

  Todo({
    this.id = 0,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.catalog,
    this.status = TodoStatus.active,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id > 0 ? id : null,
      'title': title,
      'description': description,
      'status': status.name,
      "catalog_id": catalog?.id,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
