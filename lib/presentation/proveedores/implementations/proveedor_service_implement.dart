import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/domain/repositories/proveedor_repository_base.dart';
import 'package:bancalcaj_app/domain/services/proveedor_service_base.dart';

interface class ProveedorServiceImplement implements ProveedorServiceBase{

  final ProveedorRepositoryBase repo;
  ProveedorServiceImplement(this.repo);

  @override
  Future<Result<String>> agregarProveedor(Proveedor proveedor) async {
    try {
      return Result.success(data: await repo.add(proveedor));
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<String>> agregarTipoDeProveedor(TypeProveedor tipoDeProveedor) async {
    try {
      return Result.success(data: await repo.addType(tipoDeProveedor));
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<bool>> editarProveedor(Proveedor proveedor, {required String id}) async{
    try {
      return Result.success(data: await repo.update(id, proveedor));
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<bool>> editarTipoDeProveedor(TypeProveedor tipoDeProveedor, {required String id}) {
    // TODO: implement editarTipoDeProveedor
    throw UnimplementedError();
  }

  @override
  Future<Result<bool>> eliminarProveedor(String id) {
    // TODO: implement eliminarProveedor
    throw UnimplementedError();
  }

  @override
  Future<Result<bool>> eliminarTipoDeProveedor(String id) {
    // TODO: implement eliminarTipoDeProveedor
    throw UnimplementedError();
  }

  @override
  Future<Result<PaginateData<ProveedorView>>> verProveedores({int? pagina = 1, int? limite = 5, String? nombre, String? tipoProveedor}) async {
    try {
      final paginateData = await repo.getAll(page: pagina!, limit: limite!, aditionalQueries: {
        'name': nombre ?? '',
        'type': tipoProveedor ?? ''
      });
      return Result.success(data: paginateData);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<PaginateData<TypeProveedor>>> verTiposDeProveedor({int? pagina = 1, int? limite = 5, String? nombre}) async {
    try{
      final paginateData = await repo.getAllTypes(page: pagina!, limit: limite!, aditionalQueries: {
        'name': nombre ?? ''
      });
      return Result.success(data: paginateData);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }
  
  @override
  Future<Result<Proveedor>> seleccionarProveedor(String id) async {
    try {
      final data = await repo.getById(id);
      if(data == null) throw Exception('Valor no encontrado');
      await data.ubication.fillFields();
      return Result.success(data: data);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }
  
  @override
  Future<Result<TypeProveedor>> seleccionarTipoDeProveedor(String id) async  {
    try {
      final data = await repo.getTypeById(id);
      if(data == null) throw Exception('Valor no encontrado');
      return Result.success(data: data);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

}