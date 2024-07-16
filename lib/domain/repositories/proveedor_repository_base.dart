import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/domain/interfaces/repository.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';

typedef E = Proveedor;

abstract class ProveedorRepositoryBase extends Repository<Proveedor> implements ICrudable<E>, IPaginatable<E>{
  final String dataset = 'proveedores';
  final String typeDataset = 'typeProveedores';
  
  ProveedorRepositoryBase({required super.db});

  @override Future add(E proveedor);
  @override Future<Iterable<E>> getAll();
  @override Future<E?> getById(int id);
  @override Future<PaginateData<E>?> getAllPaginated({int? page = 1, int? limit = 5, String? search});
  @override Future update(int id, E proveedor);
  @override Future delete(int id);


  //* Extra methods
  Future<Proveedor?> getByIdDetailed(int id);

  //* TypeProveedor section
  Future<String> addType(TypeProveedor typeProveedor);
  Future<Iterable<TypeProveedor>> getAllTypes();
  Future<TypeProveedor?> getTypeById(int id);
  Future deleteType(int id);
  Future updateType(int id, TypeProveedor item);
  Future<PaginateData<TypeProveedor>?> getAllTypesPaginated({int? page = 1, int? limit = 5, String? search});
}