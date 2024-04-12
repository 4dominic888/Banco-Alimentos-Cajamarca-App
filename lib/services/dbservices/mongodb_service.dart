import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';

class MongoDBService implements DataBaseService {

  //TODO: Borrar más tarde

  @override
  Future init(){
    throw UnimplementedError();
  }

  @override
  Future add(Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getById(int id) {
    throw UnimplementedError();
  }

  @override
  Future insert(int id, Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Future update(int id, Map<String, dynamic> newData) {
    throw UnimplementedError();
  }
  
}