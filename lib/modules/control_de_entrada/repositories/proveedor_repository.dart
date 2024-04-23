import 'package:bancalcaj_app/modules/control_de_entrada/classes/proveedor.dart';
import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';
import 'package:bancalcaj_app/services/dbservices/repository.dart';

class ProveedorRepository implements Repository<Proveedor>{

  final DataBaseService _context;

  ProveedorRepository(DataBaseService context): _context = context{
    _context.table = "proveedor";
  }

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
  Future<List<Proveedor>>? getAll() async {
    final json = await _context.getAll();
    if(json == null) return [];
    return json.map((e) => Proveedor(id: e["idp"], nombre: e["nombre"])).toList();
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