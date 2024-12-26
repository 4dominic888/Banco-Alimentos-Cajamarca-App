import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Tipo de dato de la petición a realizar
/// 
/// Estan `get`, `post`, `put`, `patch`y `delete`
enum RequestType { get, post, put, patch, delete }

/// Clase mapper o helper que permite la comunicación con el backend de Express
class ExpressBackend {

  /// Variable auxiliar para obtención de valores con SharedPreferences
  static final _prefs = GetIt.I<SharedPreferences>();

  /// Tiempo limite por defecto para el `timeout` de las solicitudes de la clase
  static const Duration _timeLimit = Duration(seconds: 15);

  /// Header auxiliar por defecto de las solicitudes
  static const _defaultheader = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Función auxiliar para obtener un header específico para las solicitudes
  /// 
  /// `needPermission`: En caso se neceite un permiso alguno, se agregará la clausura `Authorization` seguido de un Bearer.
  /// El token que requiere será agregado automaticamente según el token más actual guardado en el dispositivo.
  static Map<String, String> _headerMaker([bool needPermission = true]) {
    Map<String, String> newHeader = _defaultheader.toMap();
    final String? token = _prefs.getString('token');
    if(needPermission && token != null) { newHeader.addAll({'Authorization': 'Bearer $token'}); }
    return newHeader;
  }

  /// Nombre del dominio, es la URL del backend de express
  static const String _domain = 'backend-test-bacalcaj.onrender.com';

  /// Función auxiliar para hacer un encode del body o retornar null.
  /// De hecho fue creado para acortar esta lógica en términos de lineas de código, ya que se
  /// estaba llamando demasiadas veces.
  /// 
  /// `body`: Es el contenido del body a parsear
  static String? _parseBody(Map<String, dynamic>? body) => body != null ? json.encode(body) : null;


  /// Crea solicitudes http especificamente hacia el backend de express
  /// 
  /// Ejemplos:
  /// 
  /// ```dart
  /// // Para obtener la información de un proveedor
  /// final response = await ExpressBackend.solicitude('proveedores/45', RequestType.get, needPermission: true);
  /// 
  /// // Para obtener un conjunto de datos de proveedores
  /// final response = await ExpressBackend.solicitude('proveedores', RequestType.get,
  ///   queryParameters: {
  ///     'page': '2',
  ///     'limit': '10',
  ///   },
  /// needPermission: true);
  /// ```
  /// 
  /// Posibles errores que pueda tener:
  /// 
  /// `HttpException` con información del status code y respuesta especifica del backend
  /// en la salida de `message`.
  static Future<Map<String, dynamic>> solicitude(String route, RequestType requestType, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? body, bool? needPermission = false}) async {
    final uri = Uri.https(_domain, 'api/$route', queryParameters);
    late final http.Response response;

    //* Código uniforme, aunque raro y repetitivo... en fin.
    switch (requestType) {
      case RequestType.get:    {  response = await http.get(    uri,                            headers: _headerMaker(needPermission!)).timeout(_timeLimit);   break; }
      case RequestType.post:   {  response = await http.post(   uri,   body: _parseBody(body),  headers: _headerMaker(needPermission!)).timeout(_timeLimit);   break; }
      case RequestType.put:    {  response = await http.put(    uri,   body: _parseBody(body),  headers: _headerMaker(needPermission!)).timeout(_timeLimit);   break; }
      case RequestType.patch:  {  response = await http.patch(  uri,   body: _parseBody(body),  headers: _headerMaker(needPermission!)).timeout(_timeLimit);   break; }
      case RequestType.delete: {  response = await http.delete( uri,   body: _parseBody(body),  headers: _headerMaker(needPermission!)).timeout(_timeLimit);   break; }
    }

    final responseDecoded = json.decode(response.body) as Map<String, dynamic>;
    if(response.statusCode == 200) return responseDecoded;
    
    throw HttpException('status: ${response.statusCode}, ${responseDecoded['message']}', uri: uri);
  }
}