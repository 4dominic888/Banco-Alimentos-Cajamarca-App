import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MongoDBService implements DataBaseService {

  @override
  String table = "entradas";

  late String _json;

  @override
  Future<void> init() async{
    _json = await http.read(Uri.https('localhost:9000', '/api/$table'));
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
  Future<List<dynamic>> getAll() async {
    final httpEntradaURL = Uri.https('localhost:9000', '/api/$table');
    _json = await http.read(httpEntradaURL);
    return json.decode(_json);
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