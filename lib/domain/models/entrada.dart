import 'package:bancalcaj_app/domain/models/almacenero.dart';
import 'package:bancalcaj_app/domain/classes/producto.dart';
import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:intl/intl.dart';

class EntradaView {
  final String id;
  final DateTime fecha;
  final double cantidad;
  final String proveedor;
  final String almacenero;

  EntradaView({
    required this.id,
    required this.fecha,
    required this.cantidad,
    required this.proveedor,
    required this.almacenero
  });

  factory EntradaView.fromJson(Map<String, dynamic> json){
    return EntradaView(
      id: json['_id'],
      fecha: DateTime.parse(json['fecha']),
      cantidad: double.parse(json["cantidad"].toString()),
      proveedor: json['proveedor'],
      almacenero: json['almacenero']
    );
  }

    String get fechaStr => DateFormat("dd-MM-yyyy HH:mm").format(fecha);
    String get cantidadStr => cantidad.toStringAsFixed(2);

}

class Entrada {
    DateTime fecha;
    double _cantidad;
    Proveedor _proveedor;
    List<TipoProductos> _tiposProductos;
    String? _comentario;
    Almacenero _almacenero;

    Entrada({
      DateTime? fecha,
      required double cantidad,
      required Proveedor proveedor,
      required List<TipoProductos> productos,
      String? comentario,
      required Almacenero almacenero
    }) :
        fecha = fecha ?? DateTime.now(),
        _cantidad = cantidad,
        _proveedor = proveedor,
        _tiposProductos = productos,
        _comentario = comentario ?? '',
        _almacenero = almacenero
      ;

    Entrada.reduced({
      DateTime? fecha,
      required double cantidad,
      required String proveedorId,
      required List<TipoProductos> productos,
      String? comentario,
      required String almaceneroId
    }) :
        fecha = fecha ?? DateTime.now(),
        _cantidad = cantidad,
        _proveedor = Proveedor.onlyId(proveedorId),
        _tiposProductos = productos,
        _comentario = comentario ?? '',
        _almacenero = Almacenero(dni: almaceneroId, nombre: 'none')
      ;      

    factory Entrada.fromJson(Map<String, dynamic> json){
      final products = json["tipoProductos"] as List<dynamic>;
      return Entrada(
        fecha: DateTime.parse(json["fecha"]),
        cantidad: double.parse(json["cantidad"].toString()),
        proveedor: Proveedor.fromJsonLow(json["proveedor"]),
        productos: products.map((e) => TipoProductos.fromJson(e as Map<String, dynamic>)).toList(),
        comentario: json["comentario"],
        almacenero: Almacenero.fromJson(json["almacenero"])
      );
    }

    double get cantidad => _cantidad;
    Proveedor get proveedor => _proveedor;
    List<TipoProductos> get tiposProductos => _tiposProductos;
    String? get comentario =>_comentario;
    Almacenero get almacenero =>_almacenero;

    String get fechaStr => DateFormat("dd-MM-yyyy HH:mm").format(fecha);
    String get cantidadStr => _cantidad.toStringAsFixed(2);


    Map<String, dynamic> toJson(){
      return{
        "fecha" : fecha.toIso8601String(),
        "cantidad": cantidadStr,
        "proveedor": _proveedor.toJson(),
        "tipoProductos": tiposProductos.map((e) => e.toJson()).toList(),
        "comentario": _comentario,
        "almacenero": _almacenero.toJson()
      };
    }

    Map<String, dynamic> toJsonEntry(){
      return{
        "fecha" : fecha.toIso8601String(),
        "cantidad": cantidadStr,
        "proveedor": _proveedor.id.toString(),
        "tipoProductos": tiposProductos.map((e) => e.toJson()).toList(),
        "comentario": _comentario,
        "almacenero": _almacenero.dni.toString()
      };
    }

  Entrada copyWith({
    DateTime? fecha,
    double? cantidad,
    Proveedor? proveedor,
    List<TipoProductos>? tiposProductos,
    Almacenero? almacenero,
    String? comentario
  }){
    return Entrada(
      fecha: fecha ?? this.fecha,
      cantidad: cantidad ?? this.cantidad,
      proveedor: proveedor ?? this.proveedor,
      productos: tiposProductos ?? this.tiposProductos,
      almacenero: almacenero ?? this.almacenero,
      comentario: comentario ?? this.comentario,
    );
  }
}