import 'package:bancalcaj_app/domain/classes/proveedor.dart';
import 'package:bancalcaj_app/services/api_readonly_services/ubication_api.dart';
import 'package:bancalcaj_app/services/db_services/data_base_service.dart';
import 'package:bancalcaj_app/shared/repositories/repository.dart';
import 'package:bancalcaj_app/shared/util/paginate_data.dart';
import 'package:bancalcaj_app/shared/util/result.dart';

class ProveedorRepository extends Repository<Proveedor>{

  final DataBaseService _context;

  ProveedorRepository(DataBaseService context): _context = context, super('proveedores');

  @override
  Future<Result<String>> add(Proveedor item) async {
    try {
      await _context.add(item.toJsonSend(), table);
      return Result.success(data: "Proveedor guardado con exito");   
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Proveedor>> getAll() async {
    final data = await _context.getAll(table);
    return List<Proveedor>.from(data.map((e) => Proveedor.fromJson(e)));
  }

  @override
  Future<PaginateData<Proveedor>?> getAllPaginated({int? page = 1, int? limit = 5, String? search}) async {
    try {
      final PaginateData<Map<String, dynamic>>? paginateData = await _context.getAllPaginated(table, page: page, limit: limit);
      return PaginateData<Proveedor>(metadata: paginateData!.metadata, data: paginateData.data.map((e) => Proveedor.fromJson(e)).toList());  
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Proveedor?> getById(int id) async {
    final data = await _context.getById(id, table);
    if(data == null) return null;
    return Proveedor.fromJson(data);
  }

  Future<Proveedor?> getByIdDetailed(int id) async {
    final data = await _context.getById(id, table);
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
  Future<Result<String>> update(int id, Proveedor item) async {
    try {
      await _context.update(id, item.toJsonSend(), table);
      return Result.success(data: 'Se ha actualizado el elemento con exito');
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }
}