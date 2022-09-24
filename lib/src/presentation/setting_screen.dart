import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/cubit/catalog_cubit.dart';
import 'catalog_list_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text('待办事项分类管理'),
          trailing: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<CatalogCubit>(),
                      child: const CatalogListScreen(),
                    ),
                  ),
                );
              },
              child: const Icon(Icons.edit)),
        ),
      ],
    );
  }
}
