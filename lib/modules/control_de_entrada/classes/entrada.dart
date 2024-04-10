import 'package:bancalcaj_app/modules/control_de_entrada/classes/producto.dart';

class Entrada {
    int _id;
    DateTime _fecha;
    double _cantidad;
    String _proveedor;
    final List<Producto> _listaProductos;
    List<String> _tipoProductos;
    String? _comentario;

    Entrada({
      required int id,
      DateTime? fecha,
      required double cantidad,
      required String proveedor,
      required List<Producto> listaProductos,
      required List<String> tipoProducto,
      String? comentario
    }) :
        _id = id,
        _fecha = fecha ?? DateTime.now(),
        _cantidad = cantidad,
        _proveedor = proveedor,
        _listaProductos = listaProductos,
        _tipoProductos = tipoProducto,
        _comentario = comentario ?? '';


    int get id => _id;
    DateTime get fecha => _fecha;
    double get cantidad => _cantidad;
    String get proveedor => _proveedor;
    List<Producto> get listaProductos=> _listaProductos;
    List<String> get tipoProductos => _tipoProductos;
    String? get comentario =>_comentario;

    set fecha(DateTime fecha) => _fecha = fecha;
    set cantidad(double cantidad) => _cantidad = cantidad;
    set proveedor(String proveedor) => _proveedor = proveedor;
    set tipoProductos(List<String> tipoProducto) => _tipoProductos = tipoProducto;
    set comentario(String? comentario) => _comentario = comentario;

    Map<String, dynamic> toJson(){
      return{
        "_id" : _id,
        "fecha" : _fecha,
        "cantidad": _cantidad,
        "proveedor": _proveedor,
        "listaProductos": _listaProductos,
        "tipoProductos": _tipoProductos,
        "comentario": _comentario
      };
    }
}