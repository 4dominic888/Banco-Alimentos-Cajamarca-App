import 'package:bancalcaj_app/domain/classes/ubication.dart';

class ProveedorView {
  final String id;
  final String nombre;
  final String? typeProveedor;
  final Map<String, dynamic> ubication;

  ProveedorView({
    required this.id,
    required this.nombre,
    required this.ubication,
    this.typeProveedor,
  });

  factory ProveedorView.fromJson(Map<String, dynamic> json){
    return ProveedorView(
      id: json['idp'],
      nombre: json['nombre'],
      typeProveedor: json['type'],
      ubication: json['ubication']
    );
  }
}

class Proveedor{
  final String id;
  final String nombre;
  final TypeProveedor? typeProveedor;
  final Ubication ubication;

  Proveedor({required this.id, required this.nombre, required this.ubication, this.typeProveedor});
  Proveedor.toSend({required this.nombre, required this.ubication, this.typeProveedor}) : id = '0';
  
  factory Proveedor.onlyId(String id) => Proveedor(
    id: id, 
    nombre: '',
    typeProveedor: TypeProveedor(name: ''),
    ubication: Ubication.none()
  );

  factory Proveedor.fromJson(Map<String, dynamic> json){
    return Proveedor(
      id: json['idp'],
      nombre: json['nombre'],
      typeProveedor: json['type'] != null ? TypeProveedor.fromJson(json['type']) : null,
      ubication: Ubication.fromJson(json['ubication'])
    );
  }

  factory Proveedor.fromJsonWithouType(Map<String, dynamic> json){
    return Proveedor(
      id: json['idp'],
      nombre: json['nombre'],
      typeProveedor: TypeProveedor(id: '-1', name: 'unknown'),
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

  ProveedorView get proveedorView => ProveedorView(
    id: id,
    nombre: nombre,
    typeProveedor: typeProveedor?.name,
    ubication: { "countryCode": ubication.countryCode, "type": ubication.type }
  );

  ProveedorView get proveedorViewReduced => ProveedorView(
    id: id,
    nombre: nombre,
    typeProveedor: typeProveedor?.name,
    ubication: { "countryCode": '0', "type": 'none' }
  );

  Map<String, dynamic> toJson(){
    return {
      'idp': id,
      'nombre': nombre,
      'type': typeProveedor?.id,
      'ubication': ubication.toJson()
    };
  }

  Map<String, dynamic> toJsonSend(){
    return {
      'nombre': nombre,
      'type': typeProveedor?.id,
      'ubication': ubication.toJson()
    };
  }

  Proveedor copyWith({
    String? id,
    String? nombre,
    TypeProveedor? typeProveedor,
    Ubication? ubication
  }){
    return Proveedor(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      typeProveedor: typeProveedor ?? this.typeProveedor,
      ubication: ubication ?? this.ubication
    );
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
  // ignore: non_nullable_equals_parameter, hash_and_equals
  bool operator ==(dynamic other) => other != null && other is TypeProveedor && id == other.id && name == other.name;
}