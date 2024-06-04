import 'package:bancalcaj_app/modules/control_de_entrada/classes/proveedor.dart';
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
  Future<Proveedor?> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future update(int id, Proveedor item) {
    // TODO: implement update
    throw UnimplementedError();
  }
  
}