import 'package:bancalcaj_app/data/backend/express_backend.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:bancalcaj_app/domain/models/employee.dart';
import 'package:bancalcaj_app/domain/repositories/employee_repository_base.dart';
import 'package:bancalcaj_app/domain/services/employee_service_base.dart';
import 'package:bancalcaj_app/infrastructure/auth_utils.dart';
import 'package:get_it/get_it.dart';

interface class EmployeeServiceImplement extends EmployeeServiceBase{

  final EmployeeRepositoryBase repo;
  EmployeeServiceImplement(this.repo);

  @override
  Future<Result<bool>> actualizarNombre(String dni, String nombre) async {
    try {
      final result = await repo.updateName(dni, nombre);
      return Result.success(data: result);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<bool>> actualizarPassword(String dni, String password) async {
    try {
      final result = await repo.updatePassword(dni, password);
      return Result.success(data: result);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<bool>> actualizarRoles(String dni, List<EmployeeType> roles) async {
    try {
      final result = await repo.updateType(dni, roles);
      return Result.success(data: result);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<bool>> login(String dni, String password) async {
    try {
      final response = await ExpressBackend.solicitude('employee/login',
        RequestType.post,
        body: {'dni': dni, 'password': password }
      );

      await AuthUtils.setTokens(response);

      return Result.success(data: response['status']);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<bool>> logout() async {
    try {
      await AuthUtils.refreshingToken();
      final response = await ExpressBackend.solicitude('employee/logout',
        RequestType.post,
        needPermission: true
      );
      
      await AuthUtils.cleanTokens();
      GetIt.I<EmployeeGeneralState>().employee = Employee.none();
      return Result.success(data: response['status']);

    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<bool>> recuperarPassword(String dni, {required String newPassword, required String code}) async {
    try {
      await AuthUtils.refreshingToken();
      final response = await ExpressBackend.solicitude('employee/recovery-password',
        RequestType.post,
        body: { 'dni': dni, 'password': newPassword, 'code': code },
        needPermission: true
      );
      return Result.success(data: response['status']);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<String>> register(Employee employee, String password) async {
    try {
      final response = await repo.register(employee, password);
      await AuthUtils.setTokens({ 'token': response['token'], 'refreshToken': response['refreshToken'] });
      return Result.success(data: response['qr']);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<Employee?>> seleccionarEmpleado(String dni) async {
    try {
      if(dni == 'null') return Result.success(data: null);
      final data = await repo.getById(dni);
      if(data == null) throw Exception('Valor no encontrado');
      return Result.success(data: data);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<PaginateData<EmployeeView>>> verEmpleados({int? pagina = 1, int? limite = 5, String? nombre, String? dni}) async {
    try {
      final paginateData = await repo.getAll(page: pagina!, limit: limite!, aditionalQueries: {
        'dni': dni ?? '',
        'name': nombre ?? ''
      });
      return Result.success(data: paginateData);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }
  
}