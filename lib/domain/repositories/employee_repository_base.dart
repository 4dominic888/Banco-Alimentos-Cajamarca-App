import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/domain/interfaces/repository.dart';
import 'package:bancalcaj_app/domain/models/employee.dart';

typedef E = Employee;
typedef EV = EmployeeView;

abstract class EmployeeRepositoryBase extends Repository<E> implements IGetable<E, EV>, IDeletable {
  
  final String dataset = 'employee';
  EmployeeRepositoryBase({required super.db});

  @override Future<E?> getById(String dni);
  @override Future<PaginateData<EV>?> getAll({required int page, required int limit, Map<String, dynamic>? aditionalQueries});
  @override Future<bool> delete(String dni);

  Future<Map<String, dynamic>> register(E employee, String password);
  
  Future<bool> updateName(String dni, String name);
  Future<bool> updatePassword(String dni, String password);
  Future<bool> updateType(String dni, List<EmployeeType> types);
}