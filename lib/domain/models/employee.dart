enum EmployeeType{
  administrador,
  almacenero
}

class EmployeeView {
  final String dni;
  final String nombre;
  final List<String> types;

  EmployeeView({required this.nombre, required this.dni, required this.types});

  String get typesStr {
    final StringBuffer buffer = StringBuffer();

    if(types.length == 1) return types.first;

    for (int i = 0; i < types.length; i++) {
      buffer.write(types[i]);
      if (i < types.length - 1) { buffer.write(', '); }
      else { buffer.write(' & '); }
    }

    return buffer.toString();
  }

  factory EmployeeView.fromJson(Map<String, dynamic> json){
    return EmployeeView(
      nombre: json['nombre'],
      dni: json['dni'],
      types: (json['types'] is Iterable) ? (json['types'] as Iterable).map((e) => e.toString()).toList() : []
    );
  }
}

class Employee {

    final String dni;
    final String nombre;
    final List<EmployeeType> types;

    Employee({required this.nombre, required this.dni, required this.types});

    Employee.onlyDni({required this.dni}) : nombre='', types=[];

    Employee.none() : dni='', nombre='', types=[];

    factory Employee.fromJson(Map<String, dynamic> json){
      return Employee(
        nombre: json['nombre'],
        dni: json['dni'],
        types: (json['types'] is Iterable) ? (json['types'] as Iterable).map((e) => EmployeeType.values[e]).toList() : []
      );
    }

    Map<String, dynamic> toJsonPassword(String password){
      return {
        "dni": dni,
        "nombre": nombre,
        "types": types,
        "password": password
      };
    }

    Map<String, dynamic> toJson(){
      return {
        "dni": dni,
        "nombre": nombre,
        "types": types
      };
    }
}