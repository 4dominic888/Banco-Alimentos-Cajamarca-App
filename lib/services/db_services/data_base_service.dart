import 'package:bancalcaj_app/shared/util/paginate_data.dart';

abstract class DataBaseService{

  static DataBaseService? _instance;

  factory DataBaseService.getInstance(DataBaseService dbContext){
    return _instance ??= dbContext;
  }

  Future init();
  Future add(Map<String, dynamic> data, String table);
  Future insert(int id, Map<String, dynamic> data, String table);
  Future<List<dynamic>?> getAll(String table);
  Future<PaginateData<Map<String, dynamic>>?> getAllPaginate(String table, {int? page = 1, int? limit = 5, String? search});
  Future<Map<String, dynamic>> getTemp(String table);
  Future<Map<String, dynamic>?> getById(int id, String table);
  Future update(int id, Map<String, dynamic> newData, String table);
  Future delete(int id, String table);
}