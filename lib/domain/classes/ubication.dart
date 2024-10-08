import 'package:bancalcaj_app/data/opendatasoft/ubication_api.dart';
import 'package:double_linked_list/double_linked_list.dart';

class Ubication {
  final Map<String,String?> country;
  final String type;
  final DoubleLinkedList< Map<String, Map<String,String?> > >? subPlaces;

  Ubication({required this.country, required this.type, this.subPlaces});
  
  factory Ubication.none() {
    return Ubication(
      country: {},
      type: ''
    );
  }
  
  factory Ubication.fromJson(Map<String,dynamic> json){
    return Ubication(
      country: {'codigo': json['countryCode'], "nombre": null},
      type: json['type'],
      subPlaces: DoubleLinkedList.fromIterable((json['subPlaces'] as Iterable).map<Map<String, Map<String,String?> >>(
        (e) => {e['group']: {"codigo": e['subPlaceCode'], "nombre":null}},
      ))
    );
  }

  set countryName(String name) => country['nombre'] = name;
  
  set departamentoName(String name) =>
    subPlaces?.firstWhere((element) => element.keys.first == 'departamento').content.values.first['nombre'] = name;

  set provinciaName(String name) =>
    subPlaces?.firstWhere((element) => element.keys.first == 'provincia').content.values.first['nombre'] = name;

  set distritoName(String name) =>
    subPlaces?.firstWhere((element) => element.keys.first == 'distrito').content.values.first['nombre'] = name;

  String get countryCode => country['codigo']!;
  String? get departamentoCode => subPlaces?.firstWhere((element) => element.keys.first == 'departamento').content.values.first['codigo'];
  String? get provinciaCode =>    subPlaces?.firstWhere((element) => element.keys.first == 'provincia').content.values.first['codigo'];
  String? get distritoCode =>     subPlaces?.firstWhere((element) => element.keys.first == 'distrito').content.values.first['codigo'];

  String? get getCountryName => country['nombre'];
  String? get getDepartamentoName => subPlaces?.firstWhere((element) => element.keys.first == 'departamento').content.values.first['nombre'];
  String? get getProvinciaName =>    subPlaces?.firstWhere((element) => element.keys.first == 'provincia').content.values.first['nombre'];
  String? get getDistritoName =>     subPlaces?.firstWhere((element) => element.keys.first == 'distrito').content.values.first['nombre'];

  Future<void> fillFields() async {
    countryName = (await UbicationAPI.paisById(countryCode)).data!['nombre']!;

    //* Premature performance... =(
    if(type == 'national'){
      departamentoName = (await UbicationAPI.departamentoById(departamentoCode!)).data!['nombre']!;
      
      provinciaName = (await UbicationAPI.provinciaById(
        departamentoCode!,
        provinciaCode!
      )).data!['nombre']!;

      distritoName = (await UbicationAPI.distritoById(
        departamentoCode!,
        provinciaCode!,
        distritoCode!
      )).data!['nombre']!;
    }
  }
  
  @override
  String toString() {
    return """country: ${country['codigo']}-${country['nombre']}
    ${subPlaces.toString()}""";
  }

  Map<String,dynamic> toJson(){
    return {
      "countryCode": country['codigo'],
      "type": type,
      "subPlaces": subPlaces?.map(
        (element) => {
          "group": element.keys.first,
          "subPlaceCode" : element.values.first.values.first
        },
      ).toList() ?? []
    };
  }
}