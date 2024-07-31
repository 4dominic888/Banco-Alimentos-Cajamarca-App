import 'package:bancalcaj_app/data/backend/express_backend.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/domain/models/employee.dart';
import 'package:bancalcaj_app/domain/repositories/employee_repository_base.dart';
import 'package:bancalcaj_app/infrastructure/auth_utils.dart';

interface class EmployeeRepositoryImplement extends EmployeeRepositoryBase {

  EmployeeRepositoryImplement({required super.db});
  
  @override
  Future<Map<String, dynamic>> register(E employee, String password) async {
    await AuthUtils.refreshingToken();
    return ExpressBackend.solicitude('$dataset/register',
      RequestType.post,
      body: employee.toJsonPassword(password),
      needPermission: true
    );
  }
  
  @override
  Future<bool> delete(String dni) async {
    await AuthUtils.refreshingToken();
    return db.delete(dni, dataset, needPermission: true);
  }
  
  @override
  Future<PaginateData<EV>?> getAll({required int page, required int limit, Map<String, dynamic>? aditionalQueries}) async {
    await AuthUtils.refreshingToken();
    final paginateData = await db.getAll(dataset, page: page, limit: limit, aditionalQueries: aditionalQueries, needPermission: true);
    if(paginateData == null) return null;
    return PaginateData<EV>(metadata: paginateData.metadata, data: paginateData.data.map((e) => EV.fromJson(e)).toList());
  }
  
  @override
  Future<E?> getById(String dni) async {
    await AuthUtils.refreshingToken();
    final data = await db.getById(dni, dataset, needPermission: true);
    if(data == null) return null;
    return E.fromJson(data);
  }
  
  @override
  Future<bool> updateName(String dni, String name) async {
    await AuthUtils.refreshingToken();
    final response = await ExpressBackend.solicitude('$dataset/data/$dni',
      RequestType.put,
      body: { 'nombre': name },
      needPermission: true
    );

    return response['status'];
  }
  
  @override
  Future<bool> updatePassword(String dni, String password) async {
    await AuthUtils.refreshingToken();
    final response = await ExpressBackend.solicitude('$dataset/pass/$dni', 
      RequestType.put,
      body: { 'password': password },
      needPermission: true
    );

    return response['status'];
  }
  
  @override
  Future<bool> updateType(String dni, List<EmployeeType> types) async {
    await AuthUtils.refreshingToken();
    final response = await ExpressBackend.solicitude('$dataset/types/$dni', 
      RequestType.put,
      body: { 'types': types },
      needPermission: true
    );

    return response['status'];
  }
}