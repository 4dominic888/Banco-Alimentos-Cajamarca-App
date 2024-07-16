import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:bancalcaj_app/domain/models/entrada.dart';

abstract class EntradaAlimentosServiceBase{
  Future<Result<String>> agregarEntrada(Entrada entrada);
  Future<Result<bool>> editarEntrada(Entrada entrada, {required String id});
  Future<Result<bool>> eliminarEntrada(String id);
  Future<Result<PaginateData<Entrada>>> verEntradas({int? pagina = 1, int? limite = 5, String? busqueda});
  Future<Result<Entrada>> seleccionarEntrada(String id);

  Future<Result<bool>> exportarEntradaComoPdf(Entrada entrada);
  Future<Result<bool>> exportarEntradaComoExcel(Entrada entrada);
  //* Algun servicio extra mas...
}