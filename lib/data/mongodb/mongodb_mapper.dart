import 'package:bancalcaj_app/data/backend/express_backend.dart';
import 'package:bancalcaj_app/domain/interfaces/database_interface.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';

/// Proporciona métodos de CRUD ya implementados hacia el backend de Express.
/// Tiene parámetros por defecto para temas de autorización en base a tokens.
interface class MongoDBMapper implements DatabaseInterface {

  @override
  Future<void> init() async{
    
  }

  @override
  Future<String> add(Map<String, dynamic> data, String table, {bool? needPermission = false}) async {
    final response = await ExpressBackend.solicitude(table,
      RequestType.post, 
      body: data,
      needPermission: needPermission
    );

    return response['id'].toString();
  }

  @override
  Future<bool> delete(String id, String table, {bool? needPermission = false}) async {
    final response = await ExpressBackend.solicitude('$table/$id',
      RequestType.delete,
      needPermission: needPermission
    );
    return response['status'];
  }

  @override
  Future<PaginateData<Map<String, dynamic>>?> getAll(String table, {required int page, required int limit, Map<String, dynamic>? aditionalQueries, bool? needPermission = false}) async {
    
    final response = await ExpressBackend.solicitude(table,
      RequestType.get,
      queryParameters: {'page': page.toString(), 'limit': limit.toString(), ...?aditionalQueries},
      needPermission: needPermission
    );
    return PaginateData<Map<String, dynamic>>.fromJson(response);
  }

  @override
  Future<Map<String, dynamic>> getById(String id, String table, {bool? needPermission = false}) async {
    return await ExpressBackend.solicitude('$table/$id',
      RequestType.get,
      needPermission: needPermission
    );
  }

  @override
  Future<String> insert(String id, Map<String, dynamic> data, String table, {bool? needPermission = false}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> update(String id, Map<String, dynamic> newData, String table, {bool? needPermission = false}) async {   
    final response = await ExpressBackend.solicitude('$table/$id',
      RequestType.put,
      body: newData,
      needPermission: needPermission
    );
    return response['status'];
  }
}