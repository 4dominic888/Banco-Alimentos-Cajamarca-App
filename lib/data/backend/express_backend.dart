import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum RequestType { get, post, put, patch, delete }

class ExpressBackend {

  static final prefs = GetIt.I<SharedPreferences>();

  static const Duration _timeLimit = Duration(seconds: 15);
  static const header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> _headers([bool needPermission = true]) {
    Map<String, String> newHeader = header.toMap();
    final String? token = prefs.getString('token');
    if(needPermission && token != null) { newHeader.addAll({'Authorization': 'Bearer $token'}); }
    return newHeader;
  }

  static const String _domain = 'backend-test-bacalcaj.onrender.com';

  static String? parseBody(Map<String, dynamic>? body) => body != null ? json.encode(body) : null;

  static Future<Map<String, dynamic>> solicitude(String route, RequestType requestType, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? body, bool? needPermission = false}) async {
    final uri = Uri.https(_domain, 'api/$route', queryParameters);
    late final http.Response response;

    switch (requestType) {
      case RequestType.get:    {  response = await http.get(    uri,                           headers: _headers(needPermission!)).timeout(_timeLimit);   break; }
      case RequestType.post:   {  response = await http.post(   uri,   body: parseBody(body),  headers: _headers(needPermission!)).timeout(_timeLimit);   break; }
      case RequestType.put:    {  response = await http.put(    uri,   body: parseBody(body),  headers: _headers(needPermission!)).timeout(_timeLimit);   break; }
      case RequestType.patch:  {  response = await http.patch(  uri,   body: parseBody(body),  headers: _headers(needPermission!)).timeout(_timeLimit);   break; }
      case RequestType.delete: {  response = await http.delete( uri,   body: parseBody(body),  headers: _headers(needPermission!)).timeout(_timeLimit);   break; }
      default: throw ArgumentError('requestType no valido');
    }
    final responseDecoded = json.decode(response.body) as Map<String, dynamic>;
    if(response.statusCode == 200) return responseDecoded;
    
    throw HttpException('status: ${response.statusCode}, ${responseDecoded['message']}', uri: uri);
  }
}