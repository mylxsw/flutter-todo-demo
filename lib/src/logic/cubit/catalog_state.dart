part of 'catalog_cubit.dart';

abstract class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object> get props => [];
}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<Catalog> catalogs;

  const CatalogLoaded(this.catalogs);

  @override
  List<Object> get props => [catalogs];
}

class CatalogNeedUpdate extends CatalogState {}

class CatalogError extends CatalogState {
  final String message;

  const CatalogError(this.message);

  @override
  List<Object> get props => [message];
}
