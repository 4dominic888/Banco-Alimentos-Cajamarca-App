class Almacenero {
    final String _nombre;
    // ignore: non_constant_identifier_names
    final String _DNI;

    final String _firma;

    Almacenero({required String nombre, required String DNI, required String firma}) : _nombre = nombre, _DNI = DNI, _firma = firma;

    String get nombre => _nombre;
    String get DNI => _DNI;
    String get firma => _firma;
}