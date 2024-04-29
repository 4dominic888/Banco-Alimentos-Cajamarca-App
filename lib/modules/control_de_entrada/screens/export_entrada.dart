import 'package:bancalcaj_app/modules/control_de_entrada/classes/entrada.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/producto.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/repositories/entrada_alimentos_repository.dart';
import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';
import 'package:bancalcaj_app/services/file_services/excel_service.dart';
import 'package:bancalcaj_app/services/file_services/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ExportEntradaScreen extends StatefulWidget {
  const ExportEntradaScreen({super.key, required this.dbContext});
  final DataBaseService dbContext;

  @override
  State<ExportEntradaScreen> createState() => _ExportEntradaScreenState();
}

class _ExportEntradaScreenState extends State<ExportEntradaScreen> {
  
  late final EntradaAlimentosRepository entradaRepo = EntradaAlimentosRepository(widget.dbContext);
  late final PDFService _pdfService;
  late final ExcelService _excelService;
  bool _isLoading = true;

  Future<List<Entrada>> initList() async {
    final list = await entradaRepo.getAll();
    return list;
  }

  Future<void> _initService() async{
    _pdfService = PDFService();
    _excelService = ExcelService();

    await Future.wait([
      _pdfService.init(),
      _excelService.init()
    ]);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showSubProducts(BuildContext context, String title, List<Producto> list){
    return showDialog(context: context, builder: (context) => AlertDialog(
      scrollable: true,
      title: Text(title),
      content: SizedBox(
        width: 300,
        height: 300,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            final Producto p = list[index];
            return ListTile(
              title: Text(p.nombre),
              subtitle: Text('${p.pesoStr} kg'),
            );
          },
        ),
      ),
    ));
  }
  
  @override
  void initState() {
    super.initState();
    _initService();
  }

  @override
  void dispose() {
    super.dispose();
    _pdfService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          title: const Text("Exportar entrada"), 
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )),
        
        body: FutureBuilder<List<Entrada>>(
          future: initList(),
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data!.isNotEmpty){
                return SingleChildScrollView(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                itemBuilder: (context, index) { 
                                  final entrada = snapshot.data![index];
                                  return Card(
                                    child: ListTile(
                                      title: Text("${entrada.proveedor.nombre} / ${entrada.cantidadStr} kg \n ${DateFormat("dd/MM/yyyy HH:mm").format(entrada.fecha)}"),
                                      leading: const Icon(Icons.foggy),
                                      subtitle: SizedBox(
                                          child: Wrap(
                                            direction: Axis.horizontal,
                                            spacing: 10,
                                            runSpacing: 10,
                                            children: entrada.tiposProductos.map((e) => InputChip(
                                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                              label: Text(e.nombre, 
                                                style: const TextStyle(
                                                  fontSize: 12
                                                ),
                                              ),
                                              onPressed: () async => await _showSubProducts(context, e.nombre, e.productos),                          
                                            )).toList(),
                                          ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ElevatedButton(
                                            onPressed: _isLoading ? null : () async => await _excelService.printEntradaExcel(entrada),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/svg/microsoft_excel_icon.svg',
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                const Text("Excel", style: TextStyle(color: Colors.black))
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: _isLoading ? null : () async => await _pdfService.printEntradaPDF(entrada),
                                            child: const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.picture_as_pdf, color: Colors.black),
                                                Text("PDF", style: TextStyle(color: Colors.black))
                                              ],
                                            )
                                          ),
                                        ],
                                      )
                                    ),
                                  );
                                },
                              )
                            ); 
            }
            else{
              return const Center(child: Text("No hay entradas"));
            }
          }
        ),
    );
  }
}