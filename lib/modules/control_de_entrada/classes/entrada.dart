import 'package:bancalcaj_app/modules/control_de_entrada/classes/almacenero.dart';

class Entrada {
    DateTime _fecha;
    double _cantidad;
    String _proveedor;
    List<String> _tipoProducto;
    String? _comentario;
    Almacenero _almacenero;

    Entrada({DateTime? fecha, required double cantidad, required String proveedor, required List<String> tipoProducto, String? comentario, required Almacenero almacenero}) :
        _fecha = fecha ?? DateTime.now(),
        _cantidad = cantidad,
        _proveedor = proveedor,
        _tipoProducto = tipoProducto,
        _comentario = comentario ?? '',
        _almacenero = almacenero;

    DateTime get fecha => _fecha;
    double get cantidad => _cantidad;
    String get proveedor => _proveedor;
    List<String> get tipoProducto => _tipoProducto;
    String? get comentario =>_comentario;
    Almacenero get almacenero => _almacenero;

    set fecha(DateTime fecha) => _fecha = fecha;
    set cantidad(double cantidad) => _cantidad = cantidad;
    set proveedor(String proveedor) => _proveedor = proveedor;
    set tipoProducto(List<String> tipoProducto) => _tipoProducto = tipoProducto;
    set comentario(String? comentario) => _comentario = comentario;
    set almacenero(Almacenero almacenero) => _almacenero = almacenero;
}