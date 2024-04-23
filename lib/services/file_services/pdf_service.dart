import 'dart:convert';
// TODO: Android tendrá problemas con el código de descargar PDF.
import 'dart:html';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/entrada.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/producto.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFService {

  final Map<String, List<double>> posForType = {
    "Carnes": [132,307],
    "Frutas": [275,307],
    "Verduras": [408,307],
    "Abarrotes": [163,334],
    "Embutidos": [308,334],
    "Otros": [133,360]
  };

  final PdfFont _standarFont = PdfStandardFont(PdfFontFamily.helvetica, 12);

  late PdfDocument _document;
  late final List<int> _pdfBytes;
  late PdfFont _calibriBold;

  Future<void> init() async{
    _pdfBytes = await _readDocumentData("entrada_template.pdf");
    _calibriBold = await _loadFont("calibri-bold.ttf", 14);
    _document = PdfDocument(inputBytes: _pdfBytes);
  }

  Future<void> printEntradaPDF(Entrada entrada) async{

    _document = PdfDocument(inputBytes: _pdfBytes);
    final page = _document.pages[0];

    // Fecha
    drawText(entrada.fechaStr, 140, 181, page, _standarFont);

    // Cantidad
    drawText(entrada.cantidadStr, 189, 208, page, _standarFont);

    // Proveedor
    drawText(entrada.proveedor.nombre, 90, 254, page, _standarFont);

    // Tipo alimento
    Iterable<String> typeFood = entrada.productos.keys;
    for (String type in typeFood) {
      drawTypeFood(type, page);
    }

    // Otros
    final List<Producto>? otrosProduct = entrada.productos["Otros"];
    if(otrosProduct !=  null){
      final String otrosProductString = otrosProduct.map((e) => e.grupoAlimentos).join(', ');
      drawLongText(otrosProductString, 85.05, 388.395, 460.120, 67.473, page);
    }
  
    // Comentario
    if(entrada.comentario != null && entrada.comentario != "" && entrada.comentario!.isNotEmpty){
      drawLongText(entrada.comentario!, 85.05, 497.259, 460.120, 67.473, page);
    }

    // Almacenero datos
    drawText(entrada.almacenero.nombre.toUpperCase(), 82.844, 675.580, page, _calibriBold);
    drawText("DNI: ${entrada.almacenero.dni}", 82.844, 695.709, page, _calibriBold);

    List<int> bytes = await _document.save();
    AnchorElement(
      href: "data:application/octet-stream;charset=utf-16le;base64, ${base64.encode(bytes)}")
      ..setAttribute("download", "entrada_${entrada.proveedor}.pdf")
      ..click();
  }

  void dispose(){
    _document.dispose();
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/pdf/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<PdfFont> _loadFont(String path, double size) async{
    final ByteData data = await rootBundle.load('assets/font/$path');
    final Uint8List fontData = data.buffer.asUint8List();
    return PdfTrueTypeFont(fontData, size);
  }

  /// Dibuja texto plano en base a la ubicación, para palabras cortas
  void drawText(String text, double x, double y, PdfPage page, PdfFont font ){
    page.graphics.drawString(
      text, font,
      bounds: Rect.fromLTWH(x, y, 0, 0)
    );
  }

  /// Dibuja texto plano largo, debes especificar el tamaño del cuadro
  void drawLongText(String text, double x, double y, double width, double height, PdfPage page){
    page.graphics.drawString(
      text, PdfStandardFont(PdfFontFamily.helvetica, 12),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.left,
        wordWrap: PdfWordWrapType.wordOnly,
      ),
      bounds: Rect.fromLTWH(x, y, width, height)
    );
  }

  /// Dibuja las x en las opciones
  void drawTypeFood(String type, PdfPage page){
    final pos = posForType[type]!;
    page.graphics.drawString(
      "x", PdfStandardFont(PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(pos[0], pos[1], 0, 0)
    );
  }
}