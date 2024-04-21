class Almacenero {
    final String _nombre;
    final String _dni;

    Almacenero({required String nombre, required String dni}) : _nombre = nombre, _dni = dni;

    String get nombre => _nombre;
    String get dni => _dni;

    Map<String, dynamic> toJson(){
      return {
        "nombre": _nombre,
        "dni": _dni 
      };
    }
}