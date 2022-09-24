import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/src/data/repository/todo.dart';
import 'src/app.dart';
import 'src/logic/cubit/todo_cubit.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await openDatabase(
    join(await getDatabasesPath(), "todo.db"),
    onCreate: (db, version) {
      return db.execute(
        """CREATE TABLE todos(
          id INTEGER PRIMARY KEY, 
          title TEXT, 
          description TEXT, 
          status TEXT,
          created_at TIMESTAMP,
          updated_at TIMESTAMP
        )""",
      );
    },
    version: 1,
  );

  var todoRepository = TodoRepository(database);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<TodoCubit>(create: (_) => TodoCubit(todoRepository)),
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
