import 'package:bancalcaj_app/domain/models/entrada.dart';

abstract class EntradaAlimentosServiceBase{
  Future<void> agregarEntrada(Entrada entrada);
  Future<void> editarEntrada(Entrada entrada, {required String id});
  Future<void> eliminarEntrada(String id);
  Future<List<Entrada>> verEntradas({int? pagina = 1, int? limite = 5, String? busqueda});

  Future<void> exportarEntradaComoPdf(Entrada entrada);
  Future<void> exportarEntradaComoExcel(Entrada entrada);
  //* Algun servicio extra mas...
}