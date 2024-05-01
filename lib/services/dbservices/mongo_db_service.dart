import 'dart:io';

import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MongoDBService implements DataBaseService {

  static Duration timeLimit = const Duration(seconds: 15);

  Map<String, String> headers = {
      'Content-Type': 'application/json',
  };

  static String domain = 'backend-test-bacalcaj.onrender.com';

  @override
  Future<void> init() async{
    
  }

  @override
  Future<http.Response> add(Map<String, dynamic> data, String table) async {
    final uri = Uri.https(domain, 'api/$table');
    final response = await http.post(uri, headers: headers, body: jsonEncode(data)).timeout(timeLimit);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if(data.containsKey('message')){
        throw FormatException('Error al realizar solicitud post: ${data['message']['errorResponse']['errmsg']}');
      }
      return response;
    }
    throw HttpException('El servidor devolvió ${response.statusCode}', uri: uri);
  }

  @override
  Future delete(int id, String table) {
    throw UnimplementedError();
  }

  @override
  Future<List<dynamic>> getAll(String table) async {
    final uri = Uri.https(domain, 'api/$table');
    final response = await http.get(uri, headers: headers).timeout(timeLimit);
    if(response.statusCode == 200){
      return json.decode(response.body);
    }
    else{
      throw HttpException('El servidor devolvió ${response.statusCode}', uri: uri);
    }
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