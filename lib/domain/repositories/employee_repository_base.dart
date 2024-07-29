import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/domain/interfaces/repository.dart';
import 'package:bancalcaj_app/domain/models/employee.dart';

typedef E = Employee;
typedef EV = EmployeeView;

abstract class EmployeeRepositoryBase extends Repository<E> implements  IAddable<E>, IGetable<E, EV>, IDeletable {
  
  final String dataset = 'employee';
  EmployeeRepositoryBase({required super.db});

  @override Future<Map<String, dynamic>> add(E entrada);
  @override Future<E?> getById(String dni);
  @override Future<PaginateData<EV>?> getAll({required int page, required int limit, Map<String, dynamic>? aditionalQueries});
  @override Future<bool> delete(String dni);

  Future<bool> updateName(String dni, String name);
  Future<bool> updatePassword(String dni, String password);
  Future<bool> updateType(String dni, List<EmployeeView> types);

  Future<bool> recuperarPassword(String dni, {required String newPassword, required String code});

}