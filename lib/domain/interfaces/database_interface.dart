import 'package:bancalcaj_app/domain/classes/paginate_data.dart';

abstract class DatabaseInterface{

  static DatabaseInterface? _instance;

  factory DatabaseInterface.getInstance(DatabaseInterface dbContext){
    return _instance ??= dbContext;
  }

  Future init();
  Future<String> add(Map<String, dynamic> data, String table, {bool? needPermission = false});
  Future<String> insert(String id, Map<String, dynamic> data, String table, {bool? needPermission = false});
  Future<PaginateData<Map<String, dynamic>>?> getAll(String table, {required int page, required int limit, Map<String, dynamic>? aditionalQueries, bool? needPermission = false});
  Future<Map<String, dynamic>?> getById(String id, String table, {bool? needPermission = false});
  Future<bool> update(String id, Map<String, dynamic> newData, String table, {bool? needPermission = false});
  Future<bool> delete(String id, String table, {bool? needPermission = false});
}