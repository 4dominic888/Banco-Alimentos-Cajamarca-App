import 'package:bancalcaj_app/domain/models/entrada.dart';
import 'package:bancalcaj_app/domain/classes/producto.dart';
import 'package:bancalcaj_app/infrastructure/save_dialog.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

//? Estilos para celdas

final _cellStyleWithBorder =  CellStyle(
  verticalAlign: VerticalAlign.Center,
  horizontalAlign: HorizontalAlign.Center,
  fontFamily: getFontFamily(FontFamily.Calibri),
  bottomBorder: Border(borderStyle: BorderStyle.Thin),
  leftBorder: Border(borderStyle: BorderStyle.Thin),
  rightBorder: Border(borderStyle: BorderStyle.Thin),
  topBorder: Border(borderStyle: BorderStyle.Thin),
);

final _cellHeaderStyle = CellStyle(
  topBorder: Border(borderStyle: BorderStyle.Thin),
  leftBorder: Border(borderStyle: BorderStyle.Thin),
  rightBorder: Border(borderStyle: BorderStyle.Thin),
  backgroundColorHex: ExcelColor.blue400,
  verticalAlign: VerticalAlign.Center,
  horizontalAlign: HorizontalAlign.Center,
  fontFamily: getFontFamily(FontFamily.Calibri),      
  // fontColorHex: ExcelColor.white
);


class ExcelWritter{
  late Excel _excel;
  late final Uint8List _excelData;

  Future<void> init() async {
    _excelData = await _readDocumentData("Categoria alimentos.xlsx");
  }

  Future<void> printEntradaExcel(Entrada entrada) async{
    //* obtener datos del excel plantilla
    _excel = Excel.decodeBytes(_excelData);
    final sheet = _excel.tables['Categoria alimentos'];

    //* Establecer datos por defecto
    _setCellValue(text: 'Proveedor (entrada): ${entrada.proveedor?.nombre}', cellString: 'A1', sheet: sheet);
    _setCellValue(text: "Fecha: ${entrada.fechaStr}", cellString: 'D1', sheet: sheet);

    //* Obtener lista de productos general
    final allProducts = entrada.tiposProductos.expand((subList) => subList.productos).toList();

    //* Colocarlo en la tablas correspondientes  
    for (final item in allProducts) {
      if(_registerKg(item: item, sheet: sheet, words: ['arroz'], cellString: 'D3')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['fideo'], cellString: 'D4')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['papa'],  cellString: 'D5')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['yuca'],  cellString: 'D6')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['camote'],cellString: 'D7')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['almidon', 'almidones', 'harina', 'quinua', 'quínua', 'maiz', 'maíz', 'avena'], cellString: 'D8')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['menestra'], cellString: 'D9')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['semilla', 'pecana', 'mani', 'maní', 'cereal', 'girasol'], cellString: 'D10')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['leche', 'lacteo', 'lácteo', 'queso', 'mantequilla', 'manjar'], cellString: 'D11')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['roja', 'chancho'], cellString: 'D12')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['blanca', 'pollo', 'ave'], cellString: 'D13')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['embutido'], cellString: 'D14')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['menudencia'], cellString: 'D15')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['pescado', 'marisco'], cellString: 'D16')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['huevo'], cellString: 'D17')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['vegetal', 'hoja', 'verdura', 'hongo', 'champiñon'], cellString: 'D18')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['fruta'], cellString: 'D19')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['aceite', 'grasa'], cellString: 'D20')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['azucar', 'azúcar', 'dulce', 'miel', 'stevia', 'mermelada'], cellString: 'D21')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['condimento', 'especia', 'sal', 'cafe', 'café', 'infusion', 'infusión', 'canela'], cellString: 'D22')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['alimento', 'cocido'], cellString: 'D23')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['salsa'], cellString: 'D24')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['bebida', 'gaseosa', 'nectar', 'néctar', 'refresco'], cellString: 'D25')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['agua'], cellString: 'D26')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['confiteria', 'confitería', 'galleta', 'chocolate', 'caramelo'], cellString: 'D27')) continue;
      if(_registerKg(item: item, sheet: sheet, words: ['panaderia', 'panadería', 'pasteleria', 'pastelería', 'pan', 'pastel', 'keke', 'alfajor'], cellString: 'D28')) continue;
    }

    //* Aplicar formato de celda correcto
    for (int row = 1; row < 28; row++) {
      sheet?.cell(CellIndex.indexByString('B${row + 1}')).cellStyle = _cellStyleWithBorder;
      sheet?.cell(CellIndex.indexByString('C${row + 1}')).cellStyle = _cellStyleWithBorder;
      sheet?.cell(CellIndex.indexByString('D${row + 1}')).cellStyle = _cellStyleWithBorder;
    }

    sheet?.cell(CellIndex.indexByString('C29')).cellStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Right,
      verticalAlign: VerticalAlign.Center
    );

    sheet?.cell(CellIndex.indexByString('D29')).value = TextCellValue(entrada.cantidadStr);
    sheet?.cell(CellIndex.indexByString('D29')).cellStyle = CellStyle(
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center
    );

    sheet?.cell(CellIndex.indexByString('B2')).cellStyle = _cellHeaderStyle;
    sheet?.cell(CellIndex.indexByString('D2')).cellStyle = _cellHeaderStyle;

    final bytes = _excel.save();
    SaveDialog.onDownloadDir(bytes!, 
      dialogTitle: 'Guardar entrada excel',
      filename: 'entrada_${entrada.proveedor?.nombre ?? ''}_${entrada.hashCode}',
      ext: 'xlsx'
    );

  }

  bool _registerKg({required Producto item, required Sheet? sheet, required List<String> words, required String cellString}){
    if(words.any((e) => item.nombre.toLowerCase().contains(e))) {
      _setCellValue(text: item.pesoStr, cellString: cellString, sheet: sheet, isNumber: true);
      return true;
    }
    return false;
  }

  void _setCellValue({required String text, required String cellString, required Sheet? sheet, bool? isNumber}){
    sheet?.cell(CellIndex.indexByString(cellString)).value = TextCellValue(text);
    sheet?.cell(CellIndex.indexByString(cellString)).cellStyle = CellStyle(numberFormat: (isNumber ?? false) ? NumFormat.defaultNumeric : NumFormat.standard_0);
  }

  Future<Uint8List> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/excel/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}