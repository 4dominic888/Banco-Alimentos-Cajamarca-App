import 'package:bancalcaj_app/modules/control_de_entrada/classes/proveedor.dart';
import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';
import 'package:bancalcaj_app/services/dbservices/repository.dart';

class ProveedorRepository extends Repository<Proveedor>{

  final DataBaseService _context;

  ProveedorRepository(DataBaseService context): _context = context, super('proveedores');

  @override
  Future add(Proveedor item) {
    // TODO: implement add
    throw UnimplementedError();
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