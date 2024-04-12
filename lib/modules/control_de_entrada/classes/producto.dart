class Producto {
    final String _grupoAliementos;
    final double _peso;

    Producto({required String grupoAliementos, required double peso}) : _grupoAliementos = grupoAliementos, _peso = peso;

    String get grupoAlimentos=>_grupoAliementos;
    double get peso=>_peso;

    @override
    String toString() {
    return "$_grupoAliementos | $_peso	kg";
  }
}