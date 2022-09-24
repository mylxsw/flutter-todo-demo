import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/src/logic/cubit/catalog_cubit.dart';

import '../data/model/catalog.dart';

class CatalogAddScreen extends StatefulWidget {
  const CatalogAddScreen({super.key});

  @override
  State<CatalogAddScreen> createState() => _CatalogAddScreenState();
}

class _CatalogAddScreenState extends State<CatalogAddScreen> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增分类'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '名称不能为空';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  labelText: '名称',
                  icon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('请填写分类名称'),
                        backgroundColor: Colors.red,
                      ),
                    );

                    return;
                  }

                  context
                      .read<CatalogCubit>()
                      .addCatalog(Catalog(title: _nameController.text));

                  _nameController.text = '';

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('新增成功'),
                      backgroundColor: Colors.green,
                    ),
                  );
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
