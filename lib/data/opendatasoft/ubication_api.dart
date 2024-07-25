import 'dart:convert';
import 'dart:io';
import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:dartx/dartx.dart';
import 'package:http/http.dart';

//https://data.opendatasoft.com/api/explore/v2.1/catalog/datasets/geonames-countries@kering-group/records?select=impact_country%2Ciso_numeric&where=search(impact_country%2C%22ch%22)%20or%20search(iso3%2C%22ch%22)&order_by=impact_country&limit=8&exclude=impact_country%3APeru2

abstract class UbicationAPI{
  
  static const String _domain = "data.opendatasoft.com";
  static const String _path = "api/explore/v2.1/catalog/datasets/";

  static const String _national = "distritos-peru@bogota-laburbano/records";
  static const String _international = "geonames-countries@kering-group/records";


  static const Map<String, String> _headers = {
      'Content-Type': 'application/json',
  };

  static Map<String, String> _queryCountries(String? search, [int limit = -1]) {
    final query = {
      'select': 'impact_country,iso_numeric',
      'where': 'search(impact_country,"ch") or search(iso3,"ch")',
      'order_by': 'impact_country',
      'limit': '$limit',
      'exclude': 'impact_country:Peru'
    };

    if (search != null) {
      query['where'] = 'search(impact_country,"$search") or search(iso3,"$search")'; 
    }

    return query;
  }

  static Map<String, String> _queryCountriesById(String id) {
    final query = {
      'select': 'impact_country,iso_numeric',
      'where': 'iso_numeric:"$id"',
      'order_by': 'impact_country',
    };
    return query;
  }


  static const Map<String, String> _queryDepartamentos = {
    'select': 'nombdep,ccdd',
    'group_by': 'nombdep,ccdd',
    'limit': '26',
  };

  static Map<String, String> _queryDepartamentosById(String id) => {
    'select': 'nombdep,ccdd',
    'group_by': 'nombdep,ccdd',
    'where': 'ccdd:"$id"',
  };


  static Map<String, String> _queryProvincias(String ccdd, [int limit = -1]) => {
    'select': 'nombprov,ccpp',
    'where': 'ccdd:"$ccdd"',
    'group_by': 'nombprov,ccpp',
    'limit': '$limit'
  };

  static Map<String, String> _queryProvinciasById(String ccdd, String id) => {
    'select': 'nombprov,ccpp',
    'where': 'ccdd:"$ccdd" and ccpp:"$id"',
    'group_by': 'nombprov,ccpp',
  };


  static Map<String, String> _queryDistritos(String ccdd, String ccpp, [int limit = -1]) => {
    'select': 'nombdist,ccdi',
    'where': 'ccdd:"$ccdd" and ccpp:"$ccpp"',
    'group_by': 'nombdist,ccdi',
    'limit': '$limit'
  };

  static Map<String, String> _queryDistritosById(String ccdd, String ccpp, String id) => {
    'select': 'nombdist,ccdi',
    'where': 'ccdd:"$ccdd" and ccpp:"$ccpp" and ccdi:"$id"',
    'group_by': 'nombdist,ccdi',
  };


  static Future<Result<List<dynamic>>> _getAllData(Map<String, String> query, String rest) async{
    final uri = Uri.https(_domain, _path+rest, query);
    final response = await get(uri, headers: _headers);

    try {
      if(response.statusCode == 200){
        return Result.success(data: json.decode(response.body)["results"] as List<dynamic>);
      }
      else{
        throw HttpException('El servidor devolvió ${response.statusCode}', uri: uri);
      }
    } on SocketException catch (e) {
      return Result.onError(message: 'Ha ocurrido un error de conexion ${e.message}');
    }
    catch (e){
      return Result.onError(message: e.toString());
    }
  }

  static Future<Result<dynamic>> _getData(Map<String, String> query, String rest) async{
    final uri = Uri.https(_domain, _path+rest, query);
    final response = await get(uri, headers: _headers);

    try {
      if(response.statusCode == 200){
        return Result.success(data: (json.decode(response.body)["results"] as List<dynamic>).first);
      }
      else{
        throw HttpException('El servidor devolvió ${response.statusCode}', uri: uri);
      }
    } on SocketException catch (e) {
      return Result.onError(message: 'Ha ocurrido un error de conexion ${e.message}');
    }
    catch (e){
      return Result.onError(message: e.toString());
    }
  }


  static Future<Result<List<Map<String,String>>>> get departamentos async{
    final result = await _getAllData(_queryDepartamentos, _national);
    if(result.success){
      return Result.success(data: result.data!.map((e) => 
        {
          'codigo':e['ccdd'] as String,
          'nombre':(e['nombdep'] as String).toLowerCase().capitalize()
        }
      ).toList());
    }
    return Result.onError(message: result.message);
  }

  static Future<Result<Map<String,String>>> departamentoById(String id) async{
    final result = await _getData(_queryDepartamentosById(id), _national);
    if(result.success){
      return Result.success(data:
        {
          'codigo':result.data['ccdd'] as String,
          'nombre':(result.data['nombdep'] as String).toLowerCase().capitalize()
        }
      );
    }
    return Result.onError(message: result.message);
  }


  static Future<Result<List<Map<String,String>>>> provincias(String ccdd) async{
    final result = await _getAllData(_queryProvincias(ccdd), _national);
    if(result.success){
      return Result.success(data: result.data!.map((e) => 
        {
          'codigo':e['ccpp'] as String,
          'nombre':(e['nombprov'] as String).toLowerCase().capitalize()
        }
      ).toList());
    }
    return Result.onError(message: result.message);
  }

  static Future<Result<Map<String,String>>> provinciaById(String ccdd, String id) async{
    final result = await _getData(_queryProvinciasById(ccdd, id), _national);
    if(result.success){
      return Result.success(data:
        {
          'codigo':result.data['ccpp'] as String,
          'nombre':(result.data['nombprov'] as String).toLowerCase().capitalize()
        }
      );
    }
    return Result.onError(message: result.message);
  }


  static Future<Result<List<Map<String,String>>>> distritos(String ccdd, String ccdi) async{
    final result = await _getAllData(_queryDistritos(ccdd, ccdi), _national);
    if(result.success){
      return Result.success(data: result.data!.map((e) => 
        {
          'codigo':e['ccdi'] as String,
          'nombre':(e['nombdist'] as String).toLowerCase().capitalize()
        }
      ).toList());
    }
    return Result.onError(message: result.message);
  }

  static Future<Result<Map<String,String>>> distritoById(String ccdd, String ccdi, String id) async{
    final result = await _getData(_queryDistritosById(ccdd, ccdi, id), _national);
    if(result.success){
      return Result.success(data: 
        {
          'codigo':result.data['ccdi'] as String,
          'nombre':(result.data['nombdist'] as String).toLowerCase().capitalize()
        }
      );
    }
    return Result.onError(message: result.message);
  }  


  static Future<Result<List<Map<String,String>>>> paises(String? search) async {
    final result = await _getAllData(_queryCountries(search, 7), _international);
    if(result.success){
      return Result.success(data: result.data!.map((e) => 
        {
          'codigo':e['iso_numeric'] as String,
          'nombre':e['impact_country'] as String
        }
      ).toList());
    }
    return Result.onError(message: result.message);
  }

  static Future<Result<Map<String,String>>> paisById(String id) async {
    final result = await _getData(_queryCountriesById(id), _international);
    if(result.success){
      return Result.success(data:  
        {
          'codigo':result.data['iso_numeric'] as String,
          'nombre':result.data['impact_country'] as String
        }
      );
    }
    return Result.onError(message: result.message);    
  }
}