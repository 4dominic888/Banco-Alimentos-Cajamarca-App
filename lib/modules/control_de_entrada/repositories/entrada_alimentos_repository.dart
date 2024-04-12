import 'package:bancalcaj_app/modules/control_de_entrada/classes/entrada.dart';
import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';
import 'package:bancalcaj_app/services/dbservices/repository.dart';

class EntradaAlimentosRepository implements Repository<Entrada> {
  
  final DataBaseService _context;

  EntradaAlimentosRepository(DataBaseService context): _context = context;

  @override
  Future add(Entrada item) async {
      await _context.add(item.toJson());
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Entrada>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
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