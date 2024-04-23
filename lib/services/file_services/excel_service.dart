import 'package:bancalcaj_app/modules/control_de_entrada/classes/entrada.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/producto.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

  //? Estilos para celdas

  final _cellStyleTypeProduct =  CellStyle(
    verticalAlign: VerticalAlign.Center,
    horizontalAlign: HorizontalAlign.Center,
    fontFamily: getFontFamily(FontFamily.Calibri),
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
  );

  final _cellStyleAlimento =  CellStyle(
    horizontalAlign: HorizontalAlign.Center,
    fontFamily: getFontFamily(FontFamily.Calibri),
    textWrapping: TextWrapping.WrapText,
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    bottomBorder: Border(borderStyle: BorderStyle.Thin)
  );

  final _cellStylePeso =  CellStyle(
    verticalAlign: VerticalAlign.Center,
    horizontalAlign: HorizontalAlign.Center,
    fontFamily: getFontFamily(FontFamily.Calibri),
    numberFormat: NumFormat.defaultNumeric,
    bottomBorder: Border(borderStyle: BorderStyle.Thin),
    leftBorder: Border(borderStyle: BorderStyle.Thin),
    rightBorder: Border(borderStyle: BorderStyle.Thin)
  );

class ExcelService{
  late Excel _excel;
  late final Uint8List _excelData;

  Future<void> init() async{
    _excelData = await _readDocumentData("Categoria alimentos.xlsx");
  }

  Future<void> printEntradaExcel(Entrada entrada) async{
    // get excel data
    _excel = Excel.decodeBytes(_excelData);
    final sheet = _excel.tables['Categoria alimentos'];

    // Default data
    sheet?.cell(CellIndex.indexByString('A1')).value = TextCellValue(entrada.proveedor.nombre);
    sheet?.cell(CellIndex.indexByString('D1')).value = TextCellValue("Fecha: ${entrada.fechaStr}");

    // fill fields products
    final alimentos = entrada.productos;
    int iColI = 1;
    int iRowI = 2;
    int cellMerge1 = 0;
    int cellMerge2 = 0;
    late Data? initCell;

    alimentos.forEach((key, value) {
      initCell = sheet?.cell(CellIndex.indexByColumnRow(columnIndex: iColI, rowIndex: iRowI));
      initCell?.value = TextCellValue(key);
      initCell?.cellStyle = _cellStyleTypeProduct;
      cellMerge1 = iRowI;
      for (Producto p in value) {
        iColI = 2;
        initCell = sheet?.cell(CellIndex.indexByColumnRow(columnIndex: iColI, rowIndex: iRowI));
        initCell?.value = TextCellValue(p.grupoAlimentos);
        initCell?.cellStyle = _cellStyleAlimento;
        iColI++;
        initCell = sheet?.cell(CellIndex.indexByColumnRow(columnIndex: iColI, rowIndex: iRowI));
        initCell?.value = TextCellValue(p.pesoStr);
        initCell?.cellStyle = _cellStylePeso;
        cellMerge2 = iRowI;
        iRowI++;
      }
      iColI = 1;
      if(cellMerge1 != cellMerge2){
        sheet?.merge(CellIndex.indexByString('B${cellMerge1+1}'), CellIndex.indexByString('B${cellMerge2+1}'));
      }
      sheet?.setMergedCellStyle(CellIndex.indexByString('B${cellMerge1+1}'), _cellStyleTypeProduct);
    });
    iRowI++;
    initCell = sheet?.cell(CellIndex.indexByString('C$iRowI'));
    initCell?.value = const TextCellValue("Total");
    initCell?.cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Right);

    initCell = sheet?.cell(CellIndex.indexByString('D$iRowI'));
    initCell?.value = TextCellValue(entrada.cantidadStr);
    initCell?.cellStyle = _cellStylePeso;

    sheet?.setColumnWidth(0, 10.71);
    sheet?.setColumnWidth(1, 40.29);
    sheet?.setColumnWidth(2, 62.29);
    sheet?.setColumnWidth(3, 20.86);

    // sheet?.merge(CellIndex.indexByString('B2'), CellIndex.indexByString('C2'));
    _excel.save(fileName: 'entrada_${entrada.proveedor}.xlsx');

  }

  Future<Uint8List> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/excel/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}