import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/domain/interfaces/repository.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';

typedef E = Proveedor;
typedef EV = ProveedorView;

abstract class ProveedorRepositoryBase extends Repository<Proveedor> implements ICrudable<E, EV>{
  final String dataset = 'proveedores';
  final String typeDataset = 'typeProveedores';
  
  ProveedorRepositoryBase({required super.db});

  @override Future<String> add(E proveedor);
  @override Future<E?> getById(String id);
  @override Future<PaginateData<EV>?> getAll({required int page, required int limit, Map<String, dynamic>? aditionalQueries});
  @override Future<bool> update(String id, E proveedor);
  @override Future<bool> delete(String id);

  //* TypeProveedor section
  Future<String> addType(TypeProveedor typeProveedor);
  Future<TypeProveedor?> getTypeById(String id);
  Future<bool> deleteType(String id);
  Future<bool> updateType(String id, TypeProveedor item);
  Future<PaginateData<TypeProveedor>?> getAllTypes({required int page, required int limit, Map<String, dynamic>? aditionalQueries});
}