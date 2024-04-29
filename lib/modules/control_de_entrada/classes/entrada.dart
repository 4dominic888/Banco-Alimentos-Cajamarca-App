import 'package:bancalcaj_app/modules/control_de_entrada/classes/almacenero.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/producto.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/proveedor.dart';
import 'package:intl/intl.dart';

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
        _almacenero = almacenero;

      factory Entrada.fromJson(Map<String, dynamic> json){
        final products = json["tipoProductos"] as List<dynamic>;
        return Entrada(
          fecha: DateTime.parse(json["fecha"]),
          cantidad: double.parse(json["cantidad"]),
          proveedor: Proveedor.fromJson(json["proveedor"]),
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
        "fecha" : fechaStr,
        "cantidad": cantidadStr,
        "proveedor": _proveedor.toJson(),
        "tipoProductos": tiposProductos.map((e) => e.toJson()).toList(),
        "comentario": _comentario,
        "almacenero": _almacenero.toJson()
      };
    }
}