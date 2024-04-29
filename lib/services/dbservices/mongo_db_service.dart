import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MongoDBService implements DataBaseService {

  Map<String, String> headers = {
      'Content-Type': 'application/json',
  };

  static String domain = 'backend-test-bacalcaj.onrender.com';

  @override
  Future<void> init() async{
    
  }

  @override
  Future<http.Response> add(Map<String, dynamic> data, String table) async {
    final httpEntradaURL = Uri.https(domain, 'api/$table');
    return await http.post(httpEntradaURL, headers: headers, body: jsonEncode(data));
  }

  @override
  Future delete(int id, String table) {
    throw UnimplementedError();
  }

  @override
  Future<List<dynamic>> getAll(String table) async {
    final httpEntradaURL = Uri.https(domain, 'api/$table');
    final response = await http.get(httpEntradaURL, headers: headers);
    return json.decode(response.body);
  }

  @override
  Future<Map<String, dynamic>> getById(int id, String table) {
    throw UnimplementedError();
  }

  @override
  Future insert(int id, Map<String, dynamic> data, String table) {
    throw UnimplementedError();
  }

  @override
  Future update(int id, Map<String, dynamic> newData, String table) {
    throw UnimplementedError();
  }
  
}