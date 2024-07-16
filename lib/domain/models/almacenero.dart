class Almacenero {
    final String _nombre;
    final String _dni;

    Almacenero({required String nombre, required String dni}) : _nombre = nombre, _dni = dni;

    String get nombre => _nombre;
    String get dni => _dni;

    factory Almacenero.fromJson(Map<String, dynamic> json){
      return Almacenero(
        nombre: json["nombre"],
        dni: json["dni"]
      );
    }

    Map<String, dynamic> toJson(){
      return {
        "dni": _dni,
        "nombre": _nombre
      };
    }
}