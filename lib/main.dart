import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/app.dart';
import 'src/logic/cubit/todo_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoCubit>(create: (_) => TodoCubit()),
      ],
      child: MaterialApp(
        title: 'TODO',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AppScreen(),
      ),
    );
  }
}
