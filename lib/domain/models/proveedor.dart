import 'package:bancalcaj_app/domain/classes/ubication.dart';

class Proveedor{
  final String id;
  final String nombre;
  final TypeProveedor typeProveedor;
  final Ubication ubication;

  Proveedor({required this.id, required this.nombre, required this.typeProveedor, required this.ubication});
  Proveedor.toSend({required this.nombre, required this.typeProveedor, required this.ubication}) : id = '0';

  factory Proveedor.fromJson(Map<String, dynamic> json){
    return Proveedor(
      id: json['idp'],
      nombre: json['nombre'],
      typeProveedor: TypeProveedor.fromJson(json['type']),
      ubication: Ubication.fromJson(json['ubication'])
    );
  }

  factory Proveedor.fromJsonLow(Map<String, dynamic> json){
    return Proveedor(
      id: json['idp'],
      nombre: json['nombre'],
      typeProveedor: TypeProveedor(id: '-1', name: 'unknown'),
      ubication: Ubication(country: {'':''}, type: '')
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'idp': id,
      'nombre': nombre,
      'type': typeProveedor.id,
      'ubication': ubication.toJson()
    };
  }

  Map<String, dynamic> toJsonSend(){
    return {
      'idp': id,
      'nombre': nombre,
      'type': typeProveedor.id,
      'ubication': ubication.toJson()
    };
  }
}

class TypeProveedor {
  final String? id;
  final String name;

  TypeProveedor({this.id, required this.name});
  factory TypeProveedor.fromJson(Map<String,dynamic> json) => TypeProveedor(id: json['_id'], name: json['nombre']);

  Map<String,dynamic> toJson()=>{
    "nombre": name
  };

  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic other) => other != null && other is TypeProveedor && id == other.id && name == other.name;
}