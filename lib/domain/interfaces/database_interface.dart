import 'package:bancalcaj_app/domain/classes/paginate_data.dart';

abstract class DatabaseInterface{

  static DatabaseInterface? _instance;

  factory DatabaseInterface.getInstance(DatabaseInterface dbContext){
    return _instance ??= dbContext;
  }

  Future init();
  Future<String> add(Map<String, dynamic> data, String table);
  Future<String> insert(String id, Map<String, dynamic> data, String table);
  Future<PaginateData<Map<String, dynamic>>?> getAll(String table, {required int page, required int limit, Map<String, dynamic>? aditionalQueries});
  Future<Map<String, dynamic>?> getById(String id, String table);
  Future<bool> update(String id, Map<String, dynamic> newData, String table);
  Future<bool> delete(String id, String table);
}