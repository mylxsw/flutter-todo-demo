class Catalog {
  int id;
  String title;
  DateTime? createdAt;
  DateTime? updatedAt;

  Catalog({
    this.id = 0,
    required this.title,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id > 0 ? id : null,
      'title': title,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static Catalog fromMap(Map<String, Object?> map) {
    return Catalog(
      id: map['id'] as int,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
