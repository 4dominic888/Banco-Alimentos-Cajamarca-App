import 'package:bancalcaj_app/modules/proveedor_module/classes/type_proveedor.dart';
import 'package:bancalcaj_app/modules/proveedor_module/classes/ubication.dart';

class Proveedor{
  final String id;
  final String nombre;
  final TypeProveedor typeProveedor;
  final Ubication ubication;

  Proveedor({required this.id, required this.nombre, required this.typeProveedor, required this.ubication});
  Proveedor.toSend({required this.nombre, required this.typeProveedor, required this.ubication}) : id = "0";

  factory Proveedor.fromJson(Map<String, dynamic> json){
    return Proveedor(
      id: json['idp'],
      nombre: json['nombre'],
      typeProveedor: TypeProveedor(name: json['type']['nombre']),
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
}