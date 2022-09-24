import 'package:sqflite/sqflite.dart';
import 'package:todo/src/data/model/todo.dart';

class TodoRepository {
  final Database database;

  TodoRepository(this.database);

  Future<void> insertTodo(Todo todo) async {
    todo.createdAt = DateTime.now();
    todo.updatedAt = todo.createdAt;

    await database.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteTodoById(int id) async {
    await database.delete(
      'todos',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateTodoById(int id, Todo todo) async {
    todo.updatedAt = DateTime.now();
    await database.update(
      'todos',
      todo.toMap(),
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> finishTodoById(int id) async {
    await database.update(
      'todos',
      {'status': 'completed'},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> resumeTodoById(int id) async {
    await database.update(
      'todos',
      {'status': 'active'},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<Todo>> getTodoList() async {
    final List<Map<String, dynamic>> maps = await database.query('todos');

    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        status: TodoStatus.values.byName(maps[i]['status']),
        createdAt: DateTime.parse(maps[i]['created_at']),
        updatedAt: DateTime.parse(maps[i]['updated_at']),
      );
    });
  }
}
