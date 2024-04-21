class Producto {
    final String _grupoAliementos;
    final double _peso;

    Producto({required String grupoAliementos, required double peso}) : _grupoAliementos = grupoAliementos, _peso = peso;

    String get grupoAlimentos=>_grupoAliementos;
    double get peso=>_peso;
    String get pesoStr => _peso.toStringAsFixed(2);

    @override
    String toString() {
      return "$_grupoAliementos | $_peso	kg";
    }

    Map<String, dynamic> toJson(){
      return{
        "grupoAlimento": _grupoAliementos,
        "peso": _peso
      };
    }
}