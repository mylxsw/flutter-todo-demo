import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/src/data/model/catalog.dart';
import 'package:todo/src/logic/cubit/catalog_cubit.dart';
import 'package:todo/src/logic/cubit/todo_cubit.dart';

import '../data/model/todo.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _selectedCatalogId = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _catalogList = <DropdownMenuItem>[];

  @override
  void initState() {
    super.initState();

    context.read<CatalogCubit>().getCatalogList().then((value) => setState(() {
          _catalogList.add(const DropdownMenuItem(
            value: 0,
            child: Text(
              "收件箱",
              style: TextStyle(color: Color.fromARGB(255, 108, 108, 108)),
            ),
          ));
          for (var element in value) {
            _catalogList.add(
              DropdownMenuItem(
                value: element.id,
                child: Text(element.title),
              ),
            );
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增待办事项'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '标题不能为空';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  labelText: '标题',
                  icon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                minLines: 3,
                maxLines: 10,
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '详细描述',
                  icon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: '分类',
                  icon: Icon(Icons.category),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedCatalogId = value as int;
                  });
                },
                items: _catalogList,
                value: _selectedCatalogId,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('请填写标题'),
                        backgroundColor: Colors.red,
                      ),
                    );

                    return;
                  }
                  context
                      .read<TodoCubit>()
                      .addTodo(
                        Todo(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          catalog: _selectedCatalogId == 0
                              ? null
                              : Catalog(title: "", id: _selectedCatalogId),
                        ),
                      )
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('新增成功: $value'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('新增失败: $error.toString()'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 50),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: const Text(
                  '新增',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
