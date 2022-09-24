import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jiffy/jiffy.dart';

import '../data/model/todo.dart';
import '../logic/cubit/todo_cubit.dart';

class MessageBoxScreen extends StatefulWidget {
  const MessageBoxScreen({super.key});

  @override
  State<MessageBoxScreen> createState() => _MessageBoxScreenState();
}

class _MessageBoxScreenState extends State<MessageBoxScreen> {
  @override
  void initState() {
    super.initState();

    context.read<TodoCubit>().getTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(
      listener: (context, state) {
        if (state is TodoNeedUpdate) {
          context.read<TodoCubit>().getTodoList();
        }
      },
      builder: (context, state) {
        if (state is TodoLoaded) {
          return RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.blue,
            strokeWidth: 4.0,
            onRefresh: () {
              return context.read<TodoCubit>().getTodoList();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                var todo = state.todos[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Slidable(
                    groupTag: "slidable items",
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {},
                          label: "编辑",
                          backgroundColor: Colors.green,
                          icon: Icons.edit,
                          // borderRadius: BorderRadius.circular(10),
                        ),
                        // const SizedBox(width: 10),
                        SlidableAction(
                          onPressed: (context) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("提示"),
                                    content: const Text("确定删除吗？"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("取消"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<TodoCubit>()
                                              .deleteTodo(todo.id)
                                              .then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text("删除成功")),
                                            );
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("确定"),
                                      ),
                                    ],
                                  );
                                });
                          },
                          label: "删除",
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          // borderRadius: BorderRadius.circular(10),
                        ),
                        // const SizedBox(width: 10),
                      ],
                    ),
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            if (todo.status == TodoStatus.completed) {
                              context.read<TodoCubit>().resumeTodo(todo.id);
                            } else {
                              context.read<TodoCubit>().finishTodo(todo.id);
                            }
                          },
                          label:
                              todo.status == TodoStatus.completed ? "待办" : "完成",
                          icon: todo.status == TodoStatus.completed
                              ? Icons.restore
                              : Icons.check,
                          backgroundColor: todo.status == TodoStatus.completed
                              ? Colors.orange
                              : Colors.blue,
                          // borderRadius: BorderRadius.circular(10),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Container(
                        // padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            todo.status == TodoStatus.completed
                                ? const Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.query_builder,
                                  ),
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
                                    color:
                                        const Color.fromARGB(255, 60, 60, 60),
                                    decoration:
                                        todo.status == TodoStatus.completed
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                if (todo.description.isNotEmpty)
                                  Text(
                                    todo.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: const Color.fromARGB(
                                          255, 103, 103, 103),
                                      decoration:
                                          todo.status == TodoStatus.completed
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                    ),
                                  ),
                                if (todo.description.isNotEmpty)
                                  const SizedBox(height: 5),
                                SizedBox(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          todo.catalog == null
                                              ? '收件箱'
                                              : todo.catalog!.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 162, 162, 162),
                                          ),
                                          textScaleFactor: 0.8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                            Jiffy(todo.updatedAt).fromNow(),
                                            overflow: TextOverflow.ellipsis,
                                            textScaleFactor: 0.8),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
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
    );
  }
}
