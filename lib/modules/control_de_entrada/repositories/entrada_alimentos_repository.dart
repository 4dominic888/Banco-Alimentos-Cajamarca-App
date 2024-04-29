import 'package:bancalcaj_app/modules/control_de_entrada/classes/entrada.dart';
import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';
import 'package:bancalcaj_app/services/dbservices/repository.dart';

class EntradaAlimentosRepository extends Repository<Entrada> {
  
  final DataBaseService _context;

  EntradaAlimentosRepository(DataBaseService context): _context = context, super('entradas');

  @override
  Future<dynamic> add(Entrada item) async {
    return await _context.add(item.toJson(), table);
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Entrada>?> getAll() async {
    final json = await _context.getAll(table) as List<Map<String, dynamic>>;
    return json.map((e) => Entrada.fromJson(e));
  }

  @override
  Future<Entrada?> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future update(int id, Entrada item) {
    // TODO: implement update
    throw UnimplementedError();
  }
}