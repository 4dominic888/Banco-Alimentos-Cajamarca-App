import 'package:bancalcaj_app/domain/models/entrada.dart';
import 'package:bancalcaj_app/domain/classes/producto.dart';
import 'package:bancalcaj_app/infrastructure/product_filter_list.dart';
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
    int dvalue = 3;

    //* Establecer datos por defecto
    _setCellValue(text: 'Proveedor (entrada): ${entrada.proveedor?.nombre}', cellString: 'A1', sheet: sheet);
    _setCellValue(text: "Fecha: ${entrada.fechaStr}", cellString: 'D1', sheet: sheet);

    //* Obtener lista de productos general
    final allProducts = entrada.tiposProductos.expand((subList) => subList.productos).toList();

    //* Colocarlo en la tablas correspondientes  
    for (final item in allProducts) {
      dvalue = 3;
      for (final filteri in productFilterList) {
        if(_registerKg(item: item, sheet: sheet, words: filteri, cellString: 'D$dvalue')) break;
        dvalue++;
      }
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

  // bool _hasCellValue({required String cellString, required Sheet? sheet}) => sheet?.cell(CellIndex.indexByString(cellString)).value != null;

  Future<Uint8List> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/excel/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}