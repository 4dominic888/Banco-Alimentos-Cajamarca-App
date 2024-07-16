import 'package:bancalcaj_app/modules/control_de_entrada/classes/entrada.dart';
import 'package:bancalcaj_app/services/db_services/data_base_service.dart';
import 'package:bancalcaj_app/shared/repositories/repository.dart';
import 'package:bancalcaj_app/shared/util/paginate_data.dart';

class EntradaAlimentosRepository extends Repository<Entrada> {
  
  final DataBaseService _context;

  EntradaAlimentosRepository(DataBaseService context): _context = context, super('entradas');

  @override
  Future<dynamic> add(Entrada item) async {
    return await _context.add(item.toJsonEntry(), table);
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Entrada>> getAll() async {
    final data = await _context.getAll(table);
    return List.from(data.map((e) => Entrada.fromJson(e)));

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

  @override
  Future<PaginateData<Entrada>?> getAllPaginated({int? page = 1, int? limit = 5, String? search}) {
    // TODO: implement getAllPaginate
    throw UnimplementedError();
  }
}