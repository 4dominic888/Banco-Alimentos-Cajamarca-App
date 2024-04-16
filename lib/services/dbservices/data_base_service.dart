abstract class DataBaseService{

  static DataBaseService? _instance;

  factory DataBaseService.getInstance(DataBaseService dbContext){
    return _instance ??= dbContext;
  }

  Future init();
  Future add(Map<String, dynamic> data);
  Future insert(int id, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getAll();
  Future<Map<String, dynamic>> getById(int id);
  Future update(int id, Map<String, dynamic> newData);
  Future delete(int id);
}