import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/domain/repositories/proveedor_repository_base.dart';
import 'package:bancalcaj_app/data/opendatasoft/ubication_api.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';

interface class ProveedorRepositoryImplement extends ProveedorRepositoryBase{

  ProveedorRepositoryImplement({required super.db});

  @override
  Future<String> add(Proveedor proveedor) async {
    return await db.add(proveedor.toJsonSend(), dataset);
  }

  @override
  Future<PaginateData<Proveedor>?> getAll({required int page, required int limit, String? search}) async {
    try {
      final PaginateData<Map<String, dynamic>>? paginateData = await db.getAll(dataset, page: page, limit: limit, search: search);
      return PaginateData<Proveedor>(metadata: paginateData!.metadata, data: paginateData.data.map((e) => Proveedor.fromJson(e)).toList());  
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
  Future<Proveedor?> getByIdDetailed(String id) async {
    final data = await db.getById(id, dataset);
    if(data == null) return null;
    final retorno = Proveedor.fromJson(data);
    retorno.ubication.countryName = (await UbicationAPI.paisById(retorno.ubication.countryCode)).data!['nombre']!;

    //* Premature performance... =(
    if(retorno.ubication.type == 'national'){
      retorno.ubication.departamentoName = (await UbicationAPI.departamentoById(retorno.ubication.departamentoCode!)).data!['nombre']!;
      
      retorno.ubication.provinciaName = (await UbicationAPI.provinciaById(
        retorno.ubication.departamentoCode!,
        retorno.ubication.provinciaCode!
      )).data!['nombre']!;

      retorno.ubication.distritoName = (await UbicationAPI.distritoById(
        retorno.ubication.departamentoCode!,
        retorno.ubication.provinciaCode!,
        retorno.ubication.distritoCode!
      )).data!['nombre']!;
    }
    return retorno;
  }

  @override
  Future<bool> update(String id, Proveedor proveedor) async {
    return await db.update(id, proveedor.toJsonSend(), dataset);
  }

  @override
  Future<bool> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<String> addType(TypeProveedor typeProveedor) async {
    return await db.add(typeProveedor.toJson(), typeDataset);
  }
  
  @override
  Future<PaginateData<TypeProveedor>?> getAllTypes({required int page, required int limit, required String search}) {
    // TODO: implement getAllTypesPaginated
    throw UnimplementedError();
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