import 'package:double_linked_list/double_linked_list.dart';

class Ubication {
  final Map<String,String?> country;
  final String type;
  final DoubleLinkedList< Map<String, Map<String,String?> > >? subPlaces;

  Ubication({required this.country, required this.type, this.subPlaces});
  
  factory Ubication.fromJson(Map<String,dynamic> json){
    return Ubication(
      country: {"codigo": json['countryCode'], "nombre": null},
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
          "subPlaceCode" : element.values.first.keys.first
        },
      ).toList() ?? []
    };
  }
}