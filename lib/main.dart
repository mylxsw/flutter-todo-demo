import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/src/data/repository/todo.dart';
import 'src/app.dart';
import 'src/logic/cubit/catalog_cubit.dart';
import 'src/logic/cubit/todo_cubit.dart';
import 'package:path/path.dart' as p;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await openDatabase(
    p.join(await getDatabasesPath(), "todolist.db"),
    onCreate: (db, version) {
      db.execute("""CREATE TABLE todos (
          id INTEGER PRIMARY KEY, 
          title TEXT, 
          description TEXT, 
          status TEXT,
          catalog_id INTEGER,
          created_at TIMESTAMP,
          updated_at TIMESTAMP
        );""");
      db.execute("""CREATE TABLE catalogs (
          id INTEGER PRIMARY KEY, 
          title TEXT, 
          description TEXT, 
          created_at TIMESTAMP,
          updated_at TIMESTAMP
        );""");
    },
    onUpgrade: (db, oldVersion, newVersion) {},
    version: 4,
  );

  var todoRepository = TodoRepository(database);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<TodoCubit>(create: (_) => TodoCubit(todoRepository)),
      BlocProvider<CatalogCubit>(create: (_) => CatalogCubit(todoRepository)),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AppScreen(),
    );
  }
}
