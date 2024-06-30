import 'package:bancalcaj_app/modules/proveedor_module/classes/type_proveedor.dart';
import 'package:bancalcaj_app/services/db_services/data_base_service.dart';
import 'package:bancalcaj_app/shared/repositories/repository.dart';
import 'package:bancalcaj_app/shared/util/paginate_data.dart';
import 'package:bancalcaj_app/shared/util/result.dart';

class TypeProveedorRepository extends Repository<TypeProveedor> {

  final DataBaseService _context;

  TypeProveedorRepository(DataBaseService context): _context = context, super('typeProveedores');

  @override
  Future<Result<String>> add(TypeProveedor item) async {
    try {
      await _context.add(item.toJson(), table);
      return Result.success(data: "Tipo de proveedor registrado exitosamente");
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Iterable<TypeProveedor>> getAll() async {
    final data = await _context.getAll(table);
    if(data != null){
      return List<TypeProveedor>.from(data.map((e) => TypeProveedor.fromJson(e)));
    }
    return [];
  }

  @override
  Future<TypeProveedor?> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future update(int id, TypeProveedor item) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<PaginateData<TypeProveedor>> getAllPaginated({int? page = 1, int? limit = 5}) {
    // TODO: implement getAllPaginated
    throw UnimplementedError();
  }
  
}