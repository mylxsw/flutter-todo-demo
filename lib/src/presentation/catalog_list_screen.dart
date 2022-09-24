import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/src/logic/cubit/catalog_cubit.dart';
import 'package:todo/src/presentation/catalog_add_screen.dart';

class CatalogListScreen extends StatefulWidget {
  const CatalogListScreen({super.key});

  @override
  State<CatalogListScreen> createState() => _CatalogListScreenState();
}

class _CatalogListScreenState extends State<CatalogListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CatalogCubit>().getCatalogList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分类管理'),
      ),
      body: BlocConsumer<CatalogCubit, CatalogState>(
        listener: (context, state) {
          context.read<CatalogCubit>().getCatalogList();
        },
        builder: (context, state) {
          if (state is CatalogInitial || state is CatalogLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CatalogLoaded) {
            return ListView.builder(
              itemCount: state.catalogs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.catalogs[index].title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      BlocProvider.of<CatalogCubit>(context)
                          .deleteCatalog(state.catalogs[index].id);
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('未知错误'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: context.read<CatalogCubit>(),
                child: const CatalogAddScreen(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
