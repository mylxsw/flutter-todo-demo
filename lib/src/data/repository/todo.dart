import 'package:sqflite/sqflite.dart';
import '../model/catalog.dart';
import '../model/todo.dart';

class TodoRepository {
  final Database database;

  TodoRepository(this.database);

  Future<int> insertTodo(Todo todo) async {
    todo.createdAt = DateTime.now();
    todo.updatedAt = todo.createdAt;

    return await database.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteTodoById(int id) async {
    return await database.delete(
      'todos',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateTodoById(int id, Todo todo) async {
    todo.updatedAt = DateTime.now();
    return await database.update(
      'todos',
      todo.toMap(),
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> finishTodoById(int id) async {
    return await database.update(
      'todos',
      {'status': 'completed'},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> resumeTodoById(int id) async {
    return await database.update(
      'todos',
      {'status': 'active'},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<Catalog>> getCatalogs() async {
    final List<Map<String, dynamic>> queryResult =
        await database.query('catalogs');
    return queryResult.map((e) => Catalog.fromMap(e)).toList();
  }

  Future<List<Todo>> getTodoList() async {
    final List<Map<String, dynamic>> maps = await database.query('todos');

    if (maps.isEmpty) {
      return List.empty();
    }

    var catalogIds = List.of(maps)
        .takeWhile((value) => value['catalog_id'] != null)
        .map((e) => e['catalog_id'] as int)
        .toList();

    List<Map<String, dynamic>> catalogs = catalogIds.isEmpty
        ? List.empty()
        : await database.query('catalogs',
            where: 'id IN (${catalogIds.join(',')})');
    var catalogsMap = {for (var e in catalogs) e['id']: Catalog.fromMap(e)};

    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        status: TodoStatus.values.byName(maps[i]['status']),
        catalog: catalogsMap[maps[i]['catalog_id']],
        createdAt: DateTime.parse(maps[i]['created_at']),
        updatedAt: DateTime.parse(maps[i]['updated_at']),
      );
    });
  }

  Future<void> deleteCatalogById(int id) async {
    await database.delete(
      'catalogs',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> insertCatalog(Catalog catalog) async {
    catalog.createdAt = DateTime.now();
    catalog.updatedAt = catalog.createdAt;

    await database.insert(
      'catalogs',
      catalog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
