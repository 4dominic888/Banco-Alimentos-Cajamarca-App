import 'package:bancalcaj_app/domain/models/entrada.dart';
import 'package:bancalcaj_app/domain/repositories/entrada_alimentos_repository_base.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';

interface class EntradaAlimentosRepositoryImplement extends EntradaAlimentosRepositoryBase {
  
  EntradaAlimentosRepositoryImplement({required super.db});

  @override
  Future<String> add(Entrada entrada) async {
    return await db.add(entrada.toJsonEntry(), dataset);
  }

  @override
  Future<bool> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Entrada?> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<bool> update(String id, Entrada entrada) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<PaginateData<Entrada>?> getAll({required int page, required int limit, String? search}) async {
    final paginateData = await db.getAll(dataset, page: page, limit: limit, search: search);
    if(paginateData == null) return null;
    return PaginateData<Entrada>(metadata: paginateData.metadata, data: paginateData.data.map((e) => Entrada.fromJson(e)).toList());
  }

}