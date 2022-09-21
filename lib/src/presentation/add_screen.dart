import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

                  // TODO 新增逻辑
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
