import 'package:bancalcaj_app/domain/models/employee.dart';
import 'package:bancalcaj_app/domain/classes/producto.dart';
import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:intl/intl.dart';

class EntradaView {
  final String id;
  final DateTime fecha;
  final double cantidad;
  final String? proveedor;
  final String? almacenero;
  final List<String> productos;

  EntradaView({
    required this.id,
    required this.fecha,
    required this.cantidad,
    required this.productos,
    this.proveedor,
    this.almacenero,
  });

  factory EntradaView.fromJson(Map<String, dynamic> json){
    return EntradaView(
      id: json['_id'],
      fecha: DateTime.parse(json['fecha']),
      cantidad: double.parse(json["cantidad"].toString()),
      proveedor: json['proveedor'],
      almacenero: json['almacenero'],
      productos: (json['productos'] is Iterable) ? (json['productos'] as Iterable).map((e) => e.toString()).toList() : []
    );
  }

  String get fechaStr => DateFormat("dd-MM-yyyy HH:mm").format(fecha);
  String get cantidadStr => cantidad.toStringAsFixed(2);

}

class Entrada {
  DateTime? fecha = DateTime.now();
  final double cantidad;
  final Proveedor? proveedor;
  final List<TipoProductos> tiposProductos;
  final String? comentario;
  final Employee? almacenero;

  Entrada({
    this.fecha,
    required this.cantidad,
    required this.tiposProductos,
    this.proveedor,
    this.almacenero,
    this.comentario = '',
  });

  Entrada.reduced({
    this.fecha,
    required this.cantidad,
    required String proveedorId,
    required this.tiposProductos,
    required String almaceneroId,
    this.comentario,
  }) : proveedor = Proveedor.onlyId(proveedorId), almacenero = Employee.onlyDni(dni: almaceneroId);

  factory Entrada.fromJson(Map<String, dynamic> json){
    final products = json["tipoProductos"] as List<dynamic>;
    return Entrada(
      fecha: DateTime.parse(json["fecha"]),
      cantidad: double.parse(json["cantidad"].toString()),
      proveedor: json["proveedor"] != null ? Proveedor.fromJsonWithouType(json["proveedor"]) : null,
      tiposProductos: products.map((e) => TipoProductos.fromJson(e as Map<String, dynamic>)).toList(),
      comentario: json["comentario"],
      almacenero: json["almacenero"] != null ? Employee.fromJson(json["almacenero"]) : null
    );
  }

  String get fechaStr => DateFormat("dd-MM-yyyy HH:mm").format(fecha!);
  String get cantidadStr => cantidad.toStringAsFixed(2);


  Map<String, dynamic> toJson(){
    return{
      "fecha" : fecha!.toIso8601String(),
      "cantidad": cantidadStr,
      "proveedor": proveedor?.toJson(),
      "tipoProductos": tiposProductos.map((e) => e.toJson()).toList(),
      "comentario": comentario,
      "almacenero": almacenero?.toJson()
    };
  }

  Map<String, dynamic> toJsonEntry(){
    return{
      "fecha" : fecha!.toIso8601String(),
      "cantidad": cantidadStr,
      "proveedor": proveedor?.id.toString(),
      "tipoProductos": tiposProductos.map((e) => e.toJson()).toList(),
      "comentario": comentario,
      "almacenero": almacenero?.dni.toString()
    };
  }

  Entrada copyWith({
    DateTime? fecha,
    double? cantidad,
    Proveedor? proveedor,
    List<TipoProductos>? tiposProductos,
    Employee? almacenero,
    String? comentario
  }){
    return Entrada(
      fecha: fecha ?? this.fecha,
      cantidad: cantidad ?? this.cantidad,
      proveedor: proveedor ?? this.proveedor,
      tiposProductos: tiposProductos ?? this.tiposProductos,
      almacenero: almacenero ?? this.almacenero,
      comentario: comentario ?? this.comentario,
    );
  }
}