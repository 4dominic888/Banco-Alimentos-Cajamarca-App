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
  Future<http.Response> add(Map<String, dynamic> data, String table) async {
    final uri = Uri.https(domain, 'api/$table');
    final response = await http.post(uri, headers: headers, body: jsonEncode(data)).timeout(timeLimit);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if(data.containsKey('message')){
        throw FormatException('Error al realizar solicitud post: $data');
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
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final uri = Uri.https(domain, 'api/$table');
    final response = await http.get(uri, headers: headers).timeout(timeLimit);
    if(response.statusCode == 200){
      return (json.decode(response.body) as List).cast<Map<String, dynamic>>();
    }
    else{
      throw HttpException('El servidor devolvió ${response.statusCode}', uri: uri);
    }
  }

  @override
  Future<PaginateData<Map<String, dynamic>>?> getAllPaginated(String table, {int? page = 1, int? limit = 5, String? search}) async {
    final uri = Uri.https(domain, 'api/$table', {'page': page.toString(), 'limit': limit.toString(), 'search': search});
    final response = await http.get(uri, headers: headers).timeout(timeLimit);
    if(response.statusCode == 200){
      return PaginateData<Map<String, dynamic>>.fromJson(json.decode(response.body));
    }
    else{
      throw HttpException('El servidor devolvió ${response.statusCode}', uri: uri);
    }
  }

  @override
  Future<Map<String, dynamic>> getById(int id, String table) async {
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
  Future insert(int id, Map<String, dynamic> data, String table) {
    throw UnimplementedError();
  }

  @override
  Future update(int id, Map<String, dynamic> newData, String table) async {
    final uri = Uri.https(domain, 'api/$table/$id');
    final response = await http.put(uri, headers: headers, body: jsonEncode(newData)).timeout(timeLimit);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if(data.containsKey('message')){
        throw FormatException('Error al realizar solicitud put: $data');
      }
      return response;
    }
    throw HttpException('El servidor devolvió ${response.statusCode}', uri: uri);
  }
}