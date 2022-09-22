import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/src/data/model/todo.dart';
import 'package:todo/src/logic/cubit/todo_cubit.dart';
import 'package:todo/src/presentation/add_screen.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  void initState() {
    super.initState();

    context.read<TodoCubit>().getTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO'),
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                var todo = state.todos[index];
                return Slidable(
                  groupTag: "slidable items",
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {},
                        label: "编辑",
                        backgroundColor: Colors.green,
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          context.read<TodoCubit>().deleteTodo(todo.id);
                        },
                        label: "删除",
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  startActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          if (todo.status == TodoStatus.completed) {
                            context.read<TodoCubit>().redoTodo(todo.id);
                          } else {
                            context.read<TodoCubit>().finishTodo(todo.id);
                          }
                        },
                        label:
                            todo.status == TodoStatus.completed ? "待办" : "完成",
                        backgroundColor: todo.status == TodoStatus.completed
                            ? Colors.orange
                            : Colors.blue,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(todo.status == TodoStatus.completed
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todo.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 60, 60, 60),
                                  decoration:
                                      todo.status == TodoStatus.completed
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                todo.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      const Color.fromARGB(255, 103, 103, 103),
                                  decoration:
                                      todo.status == TodoStatus.completed
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is TodoLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text('加载失败'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddButtonTapped,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onAddButtonTapped() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<TodoCubit>(),
          child: const AddScreen(),
        ),
      ),
    );
  }
}
