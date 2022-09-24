import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/catalog.dart';
import '../../data/repository/todo.dart';

part 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final TodoRepository todoRepository;

  CatalogCubit(this.todoRepository) : super(CatalogInitial());

  Future<List<Catalog>> getCatalogList() async {
    var catalogs = await todoRepository.getCatalogs();
    emit(CatalogLoaded(catalogs));
    return catalogs;
  }

  Future<void> deleteCatalog(int id) async {
    emit(CatalogLoading());
    await todoRepository.deleteCatalogById(id);
    emit(CatalogNeedUpdate());
  }

  Future<void> addCatalog(Catalog catalog) async {
    emit(CatalogLoading());
    await todoRepository.insertCatalog(catalog);
    emit(CatalogNeedUpdate());
  }
}
