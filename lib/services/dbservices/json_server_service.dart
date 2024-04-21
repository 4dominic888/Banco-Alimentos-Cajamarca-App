import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JsonServerService implements DataBaseService {

  final _httpEntradaURL = Uri.https('my-json-server.typicode.com', '/4dominic888/MyJsonServer/entradas');
  late String _json;


  @override
  Future<void> init() async{
    _json = await http.read(_httpEntradaURL);
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