import 'package:bancalcaj_app/modules/proveedor_module/classes/type_proveedor.dart';
import 'package:bancalcaj_app/modules/proveedor_module/classes/ubication.dart';

class Proveedor{
  final int id;
  final String nombre;
  final TypeProveedor typeProveedor;
  final Ubication ubication;

  Proveedor({required this.id, required this.nombre, required this.typeProveedor, required this.ubication});
  Proveedor.toSend({required this.nombre, required this.typeProveedor, required this.ubication}) : id = 0;

  factory Proveedor.fromJson(Map<String, dynamic> json){
    return Proveedor(
      id: json['idp'],
      nombre: json['nombre'],
      typeProveedor: TypeProveedor.fromJson(json['type']),
      ubication: Ubication.fromJson(json['ubication'])
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
      'nombre': nombre,
      'type': typeProveedor.id,
      'ubication': ubication.toJson()
    };
  }
}