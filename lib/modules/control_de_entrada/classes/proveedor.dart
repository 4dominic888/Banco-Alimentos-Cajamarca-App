class Proveedor{
  String id;
  String nombre;

  Proveedor({required this.id, required this.nombre});

  factory Proveedor.fromJson(Map<String, dynamic> json){
    return Proveedor(id: json["idp"], nombre: json["nombre"]);
  }

  Map<String, dynamic> toJson(){
    return {
      "idp": id,
      "nombre": nombre
    };
  }
}