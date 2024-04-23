import 'package:bancalcaj_app/modules/control_de_entrada/classes/almacenero.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/entrada.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/producto.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/proveedor.dart';
import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';
import 'package:bancalcaj_app/services/dbservices/repository.dart';
import 'package:intl/intl.dart';

class EntradaAlimentosRepository implements Repository<Entrada> {
  
  final DataBaseService _context;

  EntradaAlimentosRepository(DataBaseService context): _context = context{
    _context.table = "entradas";
  }

  @override
  Future add(Entrada item) async {
    await _context.add(item.toJson());
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Entrada>>? getAll() async {
    final json = await _context.getAll();
    final List<Entrada> list = [];

    for (var e in json!) {

      final Map<String, List<Producto>> productos = {};

      final jsonProducts = e["productos"] as Map<String, dynamic>;

      jsonProducts.forEach((key, value) {
        final List<Producto> listaTipoProductos = [];
        for (var rawProducts in value) {
          listaTipoProductos.add(Producto(grupoAliementos: rawProducts["grupoAlimento"], peso: double.parse(rawProducts["peso"])));
        }
        productos[key] = listaTipoProductos;
      });

      list.add(Entrada(
        fecha: DateFormat("d/M/y").parse(e["fecha"]),
        cantidad: double.parse(e["cantidad"]),
        proveedor: Proveedor(id: e["proveedor"]["idp"], nombre: e["proveedor"]["nombre"]),
        productos: productos,
        comentario: e["comentario"],
        almacenero: Almacenero(nombre: e["almacenero"]["nombre"], dni: e["almacenero"]["dni"])
      ));
    }
    return list;
  }

  @override
  Future<Entrada?> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future update(int id, Entrada item) {
    // TODO: implement update
    throw UnimplementedError();
  }
}