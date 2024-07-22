import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/domain/repositories/proveedor_repository_base.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';

interface class ProveedorRepositoryImplement extends ProveedorRepositoryBase{

  ProveedorRepositoryImplement({required super.db});

  @override
  Future<String> add(Proveedor proveedor) async {
    return await db.add(proveedor.toJsonSend(), dataset);
  }

  @override
  Future<PaginateData<ProveedorView>?> getAll({required int page, required int limit, Map<String, dynamic>? aditionalQueries}) async {
    try {
      final PaginateData<Map<String, dynamic>>? paginateData = await db.getAll(dataset, page: page, limit: limit, aditionalQueries: aditionalQueries);
      return PaginateData<ProveedorView>(metadata: paginateData!.metadata, data: paginateData.data.map((e) => ProveedorView.fromJson(e)).toList());  
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Proveedor?> getById(String id) async {
    final data = await db.getById(id, dataset);
    if(data == null) return null;
    return Proveedor.fromJson(data);
  }

  @override
  Future<bool> update(String id, Proveedor proveedor) async {
    return await db.update(id, proveedor.toJsonSend(), dataset);
  }

  @override
  Future<bool> delete(String id) async {
    return await db.delete(id, dataset);
  }

  @override
  Future<String> addType(TypeProveedor typeProveedor) async {
    return await db.add(typeProveedor.toJson(), typeDataset);
  }
  
  @override
  Future<PaginateData<TypeProveedor>?> getAllTypes({required int page, required int limit, Map<String, dynamic>? aditionalQueries}) async {
    try {
      final PaginateData<Map<String, dynamic>>? paginateData = await db.getAll(typeDataset, page: page, limit: limit, aditionalQueries: aditionalQueries);
      return PaginateData<TypeProveedor>(metadata: paginateData!.metadata, data: paginateData.data.map((e) => TypeProveedor.fromJson(e)).toList());  
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<TypeProveedor?> getTypeById(String id) {
    // TODO: implement getTypeById
    throw UnimplementedError();
  }
  
  @override
  Future<bool> updateType(String id, TypeProveedor item) {
    // TODO: implement updateType
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteType(String id) {
    // TODO: implement deleteType
    throw UnimplementedError();
  }
}