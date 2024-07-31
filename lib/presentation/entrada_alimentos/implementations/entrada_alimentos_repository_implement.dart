import 'package:bancalcaj_app/domain/models/entrada.dart';
import 'package:bancalcaj_app/domain/repositories/entrada_alimentos_repository_base.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/infrastructure/auth_utils.dart';

interface class EntradaAlimentosRepositoryImplement extends EntradaAlimentosRepositoryBase {
  
  EntradaAlimentosRepositoryImplement({required super.db});

  @override
  Future<String> add(Entrada entrada) async {
    await AuthUtils.refreshingToken();
    return await db.add(entrada.toJsonEntry(), dataset, needPermission: true);
  }

  @override
  Future<bool> delete(String id) async {
    await AuthUtils.refreshingToken();
    return await db.delete(id, dataset, needPermission: true);
  }

  @override
  Future<Entrada?> getById(String id) async {
    await AuthUtils.refreshingToken();
    final data = await db.getById(id, dataset, needPermission: true);
    if(data == null) return null;
    return Entrada.fromJson(data);
  }

  @override
  Future<bool> update(String id, Entrada entrada) async {
    await AuthUtils.refreshingToken();
    return await db.update(id, entrada.toJsonEntry(), dataset, needPermission: true);
  }

  @override
  Future<PaginateData<EntradaView>?> getAll({required int page, required int limit, Map<String, dynamic>? aditionalQueries}) async {
    await AuthUtils.refreshingToken();
    final paginateData = await db.getAll(dataset, page: page, limit: limit, aditionalQueries: aditionalQueries, needPermission: true);
    if(paginateData == null) return null;
    return PaginateData<EntradaView>(metadata: paginateData.metadata, data: paginateData.data.map((e) => EntradaView.fromJson(e)).toList());
  }

}