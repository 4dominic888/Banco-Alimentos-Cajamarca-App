import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:bancalcaj_app/domain/models/proveedor.dart';

abstract class ProveedorServiceBase{
  Future<Result<String>> agregarProveedor(Proveedor proveedor);
  Future<Result<bool>> editarProveedor(Proveedor proveedor, {required String id});
  Future<Result<bool>> eliminarProveedor(String id);
  Future<Result<PaginateData<Proveedor>>> verProveedores({int? pagina = 1, int? limite = 5, String? busqueda});
  Future<Result<Proveedor>> seleccionarProveedor(String id);

  Future<Result<String>> agregarTipoDeProveedor(TypeProveedor tipoDeProveedor);
  Future<Result<bool>> editarTipoDeProveedor(TypeProveedor tipoDeProveedor, {required String id});
  Future<Result<bool>> eliminarTipoDeProveedor(String id);
  Future<Result<PaginateData<TypeProveedor>>> verTiposDeProveedor({int? pagina = 1, int? limite = 5, String? busqueda});
  Future<Result<TypeProveedor>> seleccionarTipoDeProveedor(String id);
}