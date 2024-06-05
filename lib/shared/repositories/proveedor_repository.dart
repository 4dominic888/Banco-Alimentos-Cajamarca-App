import 'package:bancalcaj_app/modules/control_de_entrada/classes/proveedor.dart';
import 'package:bancalcaj_app/services/api_readonly_services/ubication_api.dart';
import 'package:bancalcaj_app/services/db_services/data_base_service.dart';
import 'package:bancalcaj_app/shared/repositories/repository.dart';
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
    if(data != null){
      return List<Proveedor>.from(data.map((e) => Proveedor.fromJson(e)));
    }
    return [];
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
    if(retorno.ubication.type == 'international'){
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

    return Proveedor.fromJson(data);
  }

  @override
  Future update(int id, Proveedor item) {
    // TODO: implement update
    throw UnimplementedError();
  }
  
}