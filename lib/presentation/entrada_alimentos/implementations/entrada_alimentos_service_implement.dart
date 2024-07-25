import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:bancalcaj_app/domain/models/entrada.dart';
import 'package:bancalcaj_app/domain/repositories/entrada_alimentos_repository_base.dart';
import 'package:bancalcaj_app/domain/services/entrada_alimentos_service_base.dart';
import 'package:bancalcaj_app/infrastructure/excel_writter.dart';
import 'package:bancalcaj_app/infrastructure/pdf_writter.dart';

interface class EntradaAlimentosServiceImplement implements EntradaAlimentosServiceBase{

  final EntradaAlimentosRepositoryBase repo;
  EntradaAlimentosServiceImplement(this.repo);

  final ExcelWritter _excelWr = ExcelWritter();
  final PDFWritter _pdfWr = PDFWritter();

  @override
  Future<Result<String>> agregarEntrada(Entrada entrada) async {
    try {
      return Result.success(data: await repo.add(entrada));
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<PaginateData<EntradaView>>> verEntradas({int? pagina = 1, int? limite = 5, String? proveedor, String? almacenero}) async {
    try {
      final paginateData = await repo.getAll(page: pagina!, limit: limite!, aditionalQueries: {
        'proveedor': proveedor ?? '',
        'almacenero': almacenero ?? ''
      });
      return Result.success(data: paginateData);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<bool>> editarEntrada(Entrada entrada, {required String id}) async {
    try {
      return Result.success(data: await repo.update(id, entrada));
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }    
  }

  @override
  Future<Result<bool>> eliminarEntrada(String id) {
    // TODO: implement eliminarEntrada
    throw UnimplementedError();
  }

  @override
  Future<Result<bool>> exportarEntradaComoExcel(Entrada entrada) async {
    try {
      await _excelWr.printEntradaExcel(entrada);
      return Result.success(data: true);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }

  @override
  Future<Result<bool>> exportarEntradaComoPdf(Entrada entrada) async {
    try {
      await _pdfWr.printEntradaPDF(entrada);
      return Result.success(data: true);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }
  
  @override
  Future<Result<Entrada?>> seleccionarEntrada(String id) async {
    try {
      if(id == 'null') return Result.success(data: null);
      final data = await repo.getById(id);
      if(data == null) throw Exception('Valor no encontrado');
      return Result.success(data: data);
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }
}