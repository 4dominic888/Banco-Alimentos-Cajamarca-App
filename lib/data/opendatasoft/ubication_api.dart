import 'dart:convert';
import 'dart:io';
import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:dartx/dartx.dart';
import 'package:http/http.dart';

//https://data.opendatasoft.com/api/explore/v2.1/catalog/datasets/geonames-countries@kering-group/records?select=impact_country%2Ciso_numeric&where=search(impact_country%2C%22ch%22)%20or%20search(iso3%2C%22ch%22)&order_by=impact_country&limit=8&exclude=impact_country%3APeru2

/// Utilidad para hacer uso de la API de OpenSoftData, exactamente con paises, departamentos o distritos
/// nacionales de aca. La información que proporciona acerca de los lugares solo se limita a solo ID y nombre.
abstract class UbicationAPI{
  
  /// Nombre del dominio, las urls comparten esta entre si
  static const String _domain = "data.opendatasoft.com";

  /// Ruta extra necesaria que hace enfasis a que se usaran datasets
  static const String _path = "api/explore/v2.1/catalog/datasets/";

  /// Ruta adicional para provincias, departamentos y distrintos nacionales
  static const String _national = "distritos-peru@bogota-laburbano/records";

  /// Ruta adicional para paises internacionales
  static const String _international = "geonames-countries@kering-group/records";

  /// Header por defecto.
  static const Map<String, String> _headers = {
      'Content-Type': 'application/json',
  };

  /// Genera una query específica para buscar paises basados en el nombre, se excluye el pais
  /// nacional de origen.
  /// 
  /// La búsqueda del nombre es referencial y no debe ser exacta para encontrar resultados.
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

  /// Genera una query específica para buscar la información de un pais basado en
  /// su ID.
  static Map<String, String> _queryCountriesById(String id) {
    final query = {
      'select': 'impact_country,iso_numeric',
      'where': 'iso_numeric:"$id"',
      'order_by': 'impact_country',
    };
    return query;
  }

  /// Genera una query específica para buscar departamentos basados en el nombre.
  /// 
  /// La búsqueda del nombre es referencial y no debe ser exacta para encontrar resultados.
  static const Map<String, String> _queryDepartamentos = {
    'select': 'nombdep,ccdd',
    'group_by': 'nombdep,ccdd',
    'limit': '26',
  };

  /// Genera una query específica para buscar la información de un departamento basado en
  /// su ID.
  /// 
  /// `id`: ID del departamento a buscar
  static Map<String, String> _queryDepartamentosById(String id) => {
    'select': 'nombdep,ccdd',
    'group_by': 'nombdep,ccdd',
    'where': 'ccdd:"$id"',
  };

  /// Genera una query específica para buscar todas provincias de un departamento basado en
  /// el id de este mismo. Es posible establecer la cantidad de registro a mostrar.
  /// 
  /// `ccdd`: ID del departamento.
  static Map<String, String> _queryProvincias(String ccdd, [int limit = -1]) => {
    'select': 'nombprov,ccpp',
    'where': 'ccdd:"$ccdd"',
    'group_by': 'nombprov,ccpp',
    'limit': '$limit'
  };

  /// Genera una query específica para buscar una provincia específica de un departamento basado en
  /// el id de este mismo.
  /// 
  /// `ccdd`: ID del departamento.
  /// 
  /// `id`: ID de la provincia a buscar
  static Map<String, String> _queryProvinciasById(String ccdd, String id) => {
    'select': 'nombprov,ccpp',
    'where': 'ccdd:"$ccdd" and ccpp:"$id"',
    'group_by': 'nombprov,ccpp',
  };

  /// Genera una query específica para buscar todos los distritos de una provincia, de un departamento basado en
  /// el id de estos mismo. Es posible establecer la cantidad de registro a mostrar.
  /// 
  /// `ccdd`: ID del departamento.
  /// 
  /// `ccpp`: ID de la provincia.
  static Map<String, String> _queryDistritos(String ccdd, String ccpp, [int limit = -1]) => {
    'select': 'nombdist,ccdi',
    'where': 'ccdd:"$ccdd" and ccpp:"$ccpp"',
    'group_by': 'nombdist,ccdi',
    'limit': '$limit'
  };

  /// Genera una query específica para buscar un distrito, en una provincia específica,de un departamento basado en
  /// el id de estos mismos.
  /// 
  /// `ccdd`: ID del departamento.
  /// 
  /// `ccpp`: ID de la provincia.
  /// 
  /// `id`: ID del distrinto a buscar
  static Map<String, String> _queryDistritosById(String ccdd, String ccpp, String id) => {
    'select': 'nombdist,ccdi',
    'where': 'ccdd:"$ccdd" and ccpp:"$ccpp" and ccdi:"$id"',
    'group_by': 'nombdist,ccdi',
  };

  /// Recupera un conjunto de información de OpenSoftData acerca de ubicaciones
  /// 
  /// `query`: Parametros adicionales de búsqueda, usar los atributos privados específicos
  /// de la clase para realizar esto de manera más sencilla
  /// 
  /// `rest`: El resto de la ruta, que vendría a especificar si va a buscar en el dataset
  /// nacional o internacional.
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

  /// Recupera solo un registro de OpenSoftData acerca de ubicaciones
  /// 
  /// `query`: Parametros adicionales de búsqueda, usar los atributos privados específicos
  /// de la clase para realizar esto de manera más sencilla
  /// 
  /// `rest`: El resto de la ruta, que vendría a especificar si va a buscar en el dataset
  /// nacional o internacional.
  /// 
  /// Pueden haber errores como [HttpException] si el error es del servidor, o [SocketException] si
  /// es un error de conexión o baja latencia.
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

  /// Obtén todos el dataset de los departamentos de Perú.
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

  /// Obtención de un departamento de Perú, basado en el ID
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

  /// Obten todas las provincias de un determinado departamento, pasa `ccdd` como id para este mismo
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

  /// Obten una provincia de un determinado departamento, pasa `ccdd` como id de departamento
  /// y `id` como id de la provincia.
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

/// Obten todos los distrintos de una determinada provincia, de un determinado departamento, pasa 
/// `ccdd` como id de departamento y `ccdi` como id de provincia.
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

  /// Obten un distrinto de una determinada provincia, de un determinado departamento, pasa 
  /// `ccdd` como id de departamento, `ccdi` como id de provincia y `id` como id de distrito.
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

  /// Obten todos los paises del mundo en base a una búsqueda que realices con el parámetro `search`.
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

  /// Obten un pais en particular en base a la `id` proporcionada.
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