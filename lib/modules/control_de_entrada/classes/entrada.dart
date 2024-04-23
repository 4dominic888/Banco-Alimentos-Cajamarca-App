import 'package:bancalcaj_app/modules/control_de_entrada/classes/almacenero.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/producto.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/proveedor.dart';
import 'package:intl/intl.dart';

class Entrada {
    DateTime _fecha;
    double _cantidad;
    Proveedor _proveedor;
    Map<String, List<Producto>> _productos;
    String? _comentario;
    Almacenero _almacenero;

    Entrada({
      DateTime? fecha,
      required double cantidad,
      required Proveedor proveedor,
      required Map<String, List<Producto>> productos,
      String? comentario,
      required Almacenero almacenero
    }) :
        _fecha = fecha ?? DateTime.now(),
        _cantidad = cantidad,
        _proveedor = proveedor,
        _productos = productos,
        _comentario = comentario ?? '',
        _almacenero = almacenero;


    DateTime get fecha => _fecha;
    double get cantidad => _cantidad;
    Proveedor get proveedor => _proveedor;
    Map<String, List<Producto>> get productos => _productos;
    String? get comentario =>_comentario;
    Almacenero get almacenero =>_almacenero;

    String get fechaStr => DateFormat("dd-MM-yyyy").format(_fecha);
    String get cantidadStr => _cantidad.toStringAsFixed(2);

    set fecha(DateTime fecha) => _fecha = fecha;
    set cantidad(double cantidad) => _cantidad = cantidad;
    set proveedor(Proveedor proveedor) => _proveedor = proveedor;
    set comentario(String? comentario) => _comentario = comentario;

    Map<String, dynamic> toJson(){
      Map<String, List<Map<String, dynamic>>> productos = 
        _productos.map((key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()));

      return{
        "id": 0,
        "fecha" : _fecha,
        "cantidad": _cantidad,
        "proveedor": _proveedor.toJson(),
        "productos": productos,
        "comentario": _comentario,
        "almacenero": _almacenero.toJson()
      };
    }
}