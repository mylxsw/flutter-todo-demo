import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

    BlocProvider.of<TodoCubit>(context).getTodoList();
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
                          BlocProvider.of<TodoCubit>(context)
                              .deleteTodo(state.todos[index].id);
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
                        onPressed: (context) {},
                        label: "完成",
                        backgroundColor: Colors.blue,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          const Icon(Icons.abc),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.todos[index].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 60, 60, 60),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                state.todos[index].description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 103, 103, 103),
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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AddScreen()));
  }
}
