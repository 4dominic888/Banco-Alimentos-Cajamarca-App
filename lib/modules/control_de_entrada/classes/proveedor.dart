class Proveedor{
  String id;
  String nombre;

  Proveedor({required this.id, required this.nombre});

  Map<String, dynamic> toJson(){
    return {
      "idp": id,
      "nombre": nombre
    };
  }
}