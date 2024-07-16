import 'package:bancalcaj_app/domain/classes/proveedor.dart';

abstract class ProveedorServiceBase{
  Future<void> agregarProveedor(Proveedor proveedor);
  Future<void> editarProveedor(Proveedor proveedor, {required String id});
  Future<void> eliminarProveedor(String id);
  Future<List<Proveedor>> verEntradas({int? pagina = 1, int? limite = 5, String? busqueda});

  Future<void> agregarTipoDeProveedor(TypeProveedor tipoDeProveedor);
  Future<void> editarTipoDeProveedor(TypeProveedor tipoDeProveedor, {required String id});
  Future<void> eliminarTipoDeProveedor(String id);
  Future<List<TypeProveedor>> verTiposDeProveedor({int? pagina = 1, int? limite = 5, String? busqueda});
}