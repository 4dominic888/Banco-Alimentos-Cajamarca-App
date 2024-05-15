import 'dart:convert';
import 'dart:io';
import 'package:dartx/dartx.dart';
import 'package:http/http.dart';

class UbicationApi{
  
  static const String _domain = "data.opendatasoft.com";
  static const String _path = "api/explore/v2.1/catalog/datasets/distritos-peru@bogota-laburbano/records";

  static const Map<String, String> _headers = {
      'Content-Type': 'application/json',
  };

  static const Map<String, String> _queryDepartamentos = {
    'select': 'nombdep,ccdd',
    'group_by': 'nombdep,ccdd',
    'limit': '26',
  };

  static Map<String, String> _queryProvincias(String ccdd, [int limit = -1]) => {
    'select': 'nombprov,ccpp',
    'where': 'ccdd:"$ccdd"',
    'group_by': 'nombprov,ccpp',
    'limit': '$limit'
  };

  static Map<String, String> _queryDistritos(String ccdd, String ccdi, [int limit = -1]) => {
    'select': 'nombdist,ccdi',
    'where': 'ccdd:"$ccdd" and ccpp:"$ccdi"',
    'group_by': 'nombdist,ccdi',
    'limit': '$limit'
  };

  static Future<List<dynamic>> _getAllData(Map<String, String> query) async{
    final uri = Uri.https(_domain, _path, query);
    final response = await get(uri, headers: _headers);
    if(response.statusCode == 200){
      return json.decode(response.body)["results"] as List<dynamic>;
    }
    else{
      throw HttpException('El servidor devolvió ${response.statusCode}', uri: uri);
    }
  }

  static Future<List<Map<String,String>>> get departamentos async{
    final data = await _getAllData(_queryDepartamentos);
    return data.map((e) => 
      {
        'codigo':e['ccdd'] as String,
        'nombre':(e['nombdep'] as String).toLowerCase().capitalize()
      }
    ).toList();
  }

  static Future<List<Map<String,String>>> provincias(String ccdd) async{
    final data = await _getAllData(_queryProvincias(ccdd));
    return data.map((e) => 
      {
        'codigo':e['ccpp'] as String,
        'nombre':(e['nombprov'] as String).toLowerCase().capitalize()
      }
    ).toList();
  }

  static Future<List<Map<String,String>>> distritos(String ccdd, String ccdi) async{
    final data = await _getAllData(_queryDistritos(ccdd, ccdi));
    return data.map((e) => 
      {
        'codigo':e['ccdi'] as String,
        'nombre':(e['nombdist'] as String).toLowerCase().capitalize()
      }
    ).toList();
  }  

}