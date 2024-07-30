import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/domain/models/employee.dart';

import '../classes/result.dart';

abstract class EmployeeServiceBase{
  Future<Result<String>> register(Employee employee, String password);
  Future<Result<bool>> login(String dni, String password);
  Future<Result<bool>> logout();

  Future<Result<PaginateData<EmployeeView>>> verEmpleados({int? pagina = 1, int? limite = 5, String? nombre, String? dni});
  Future<Result<Employee?>> seleccionarEmpleado(String dni);
  
  Future<Result<bool>> recuperarPassword(String dni, {required String newPassword, required String code});

  Future<Result<bool>> actualizarNombre(String dni, String nombre);
  Future<Result<bool>> actualizarRoles(String dni, List<EmployeeType> roles);
  Future<Result<bool>> actualizarPassword(String dni, String password);
}