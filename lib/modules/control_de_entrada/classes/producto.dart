class Producto {
    final String _nombre;
    final double _peso;

    String get nombre=>_nombre;
    double get peso=>_peso;
    String get pesoStr => _peso.toStringAsFixed(2);

    Producto({required String nombre, required double peso}) : _nombre = nombre, _peso = peso;

    factory Producto.fromJson(Map<String, dynamic> json){
      return Producto(nombre: json["nombre"], peso: double.parse(json["peso"].toString()));
    }

    @override
    String toString() {
      return "$_nombre | $_peso	kg";
    }

    Map<String, dynamic> toJson(){
      return{
        "nombre": _nombre,
        "peso": _peso
      };
    }
}

class TipoProductos{
  final String nombre;
  final List<Producto> productos;

  TipoProductos({required this.nombre, required this.productos});

  factory TipoProductos.fromJson(Map<String, dynamic> json){
    final parsedProducts = json["productos"] as List<dynamic>;
    return TipoProductos(
      nombre: json["nombre"],
      productos: parsedProducts.map((e) => Producto.fromJson(e as Map<String, dynamic>)).toList()
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "nombre": nombre,
      "productos": productos.map((e) => e.toJson()).toList()
    };
  }
}