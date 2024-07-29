import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/domain/models/employee.dart';

import '../classes/result.dart';

abstract class EmployeeServiceBase{
  Future<Result<Map<String, dynamic>>> register(Employee entrada);
  Future<Result<Map<String, dynamic>>> login(String dni, String password);
  Future<Result<bool>> logout();

  Future<Result<Map<String, dynamic>>> refreshToken();

  Future<Result<PaginateData<Employee>>> verEmpleados({int? pagina = 1, int? limite = 5, String? nombre, String? dni});
  Future<Result<Employee?>> seleccionarEmpleado(String dni);
  
  Future<Result<bool>> actualizarNombre(String nombre);
  Future<Result<bool>> actualizarRoles(List<EmployeeType> roles);
  Future<Result<bool>> actualizarPassword(String password);
}