import 'dart:io';

import 'package:bancalcaj_app/domain/interfaces/database_interface.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

interface class MongoDBMapper implements DatabaseInterface {

  static const Duration timeLimit = Duration(seconds: 15);

  static const Map<String, String> headers = {
      'Content-Type': 'application/json',
  };

  static const String domain = 'backend-test-bacalcaj.onrender.com';

  @override
  Future<void> init() async{
    
  }

  @override
  Future<String> add(Map<String, dynamic> data, String table) async {
    final uri = Uri.https(domain, 'api/$table');
    final response = await http.post(uri, headers: headers, body: jsonEncode(data)).timeout(timeLimit);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if(data.containsKey('message')){
        throw FormatException('Error al realizar solicitud post: $data');
      }
      return data['id'].toString();
    }
    throw HttpException('El servidor devolvió ${response.statusCode}', uri: uri);
  }

  @override
  Future<bool> delete(String id, String table) async {
    final uri = Uri.https(domain, 'api/$table/$id');
    final response = await http.delete(uri, headers: headers).timeout(timeLimit);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if(data.containsKey('message')){
        throw FormatException('Error al realizar solicitud put: $data');
      }
      return data['status'];
    }
    throw HttpException('El servidor devolvió ${response.statusCode}', uri: uri);  }

  @override
  Future<PaginateData<Map<String, dynamic>>?> getAll(String table, {required int page, required int limit, Map<String, dynamic>? aditionalQueries}) async {
    
    final uri = Uri.https(domain, 'api/$table', {'page': page.toString(), 'limit': limit.toString(), ...?aditionalQueries });
    final response = await http.get(uri, headers: headers).timeout(timeLimit);
    if(response.statusCode == 200){
      return PaginateData<Map<String, dynamic>>.fromJson(json.decode(response.body));
    }
    else{
      throw HttpException('El servidor devolvió ${response.statusCode}', uri: uri);
    }
  }

  @override
  Future<Map<String, dynamic>> getById(String id, String table) async {
    final uri = Uri.https(domain, 'api/$table/$id');
    final response = await http.get(uri, headers: headers).timeout(timeLimit);
    if(response.statusCode == 200){
      return json.decode(response.body);
    }
    else{
      throw HttpException('El servidor devolvió ${response.statusCode}', uri: uri);
    }
  }

  @override
  Future<String> insert(String id, Map<String, dynamic> data, String table) {
    throw UnimplementedError();
  }

  @override
  Future<bool> update(String id, Map<String, dynamic> newData, String table) async {
    final uri = Uri.https(domain, 'api/$table/$id');
    final response = await http.put(uri, headers: headers, body: jsonEncode(newData)).timeout(timeLimit);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if(data.containsKey('message')){
        throw FormatException('Error al realizar solicitud put: $data');
      }
      return data['status'];
    }
    throw HttpException('El servidor devolvió ${response.statusCode}', uri: uri);
  }
}