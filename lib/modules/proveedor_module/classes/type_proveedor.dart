class TypeProveedor {
  final String? id;
  final String name;

  TypeProveedor({this.id, required this.name});
  factory TypeProveedor.fromJson(Map<String,dynamic> json) => TypeProveedor(id: json['_id'], name: json['nombre']);

  Map<String,dynamic> toJson()=>{
    "nombre": name
  };

  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic other) => other != null && other is TypeProveedor && id == other.id && name == other.name;
}