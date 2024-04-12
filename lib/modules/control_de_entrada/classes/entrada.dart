import 'package:bancalcaj_app/modules/control_de_entrada/classes/producto.dart';

class Entrada {
    DateTime _fecha;
    double _cantidad;
    String _proveedor;
    Map<String, List<Producto>> _productos;
    String? _comentario;

    Entrada({
      DateTime? fecha,
      required double cantidad,
      required String proveedor,
      required Map<String, List<Producto>> productos,
      String? comentario
    }) :
        _fecha = fecha ?? DateTime.now(),
        _cantidad = cantidad,
        _proveedor = proveedor,
        _productos = productos,
        _comentario = comentario ?? '';


    DateTime get fecha => _fecha;
    double get cantidad => _cantidad;
    String get proveedor => _proveedor;
    Map<String, List<Producto>> get productos => _productos;
    String? get comentario =>_comentario;

    set fecha(DateTime fecha) => _fecha = fecha;
    set cantidad(double cantidad) => _cantidad = cantidad;
    set proveedor(String proveedor) => _proveedor = proveedor;
    set comentario(String? comentario) => _comentario = comentario;

    Map<String, dynamic> toJson(){
      return{
        "fecha" : _fecha,
        "cantidad": _cantidad,
        "proveedor": _proveedor,
        "productos": _productos,
        "comentario": _comentario
      };
    }
}