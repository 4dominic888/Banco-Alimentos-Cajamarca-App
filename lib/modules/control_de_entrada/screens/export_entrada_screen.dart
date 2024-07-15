import 'dart:async';

import 'package:bancalcaj_app/modules/control_de_entrada/classes/entrada.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/producto.dart';
import 'package:bancalcaj_app/shared/repositories/entrada_alimentos_repository.dart';
import 'package:bancalcaj_app/services/db_services/data_base_service.dart';
import 'package:bancalcaj_app/services/file_services/excel_service.dart';
import 'package:bancalcaj_app/services/file_services/pdf_service.dart';
import 'package:bancalcaj_app/shared/repositories/proveedor_repository.dart';
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
  
  late final EntradaAlimentosRepository entradaRepo;
  late final ProveedorRepository proveedorRepo;
  late final PDFService _pdfService;
  late final ExcelService _excelService;
  bool _isLoading = false;

  Future<List<Entrada>> initList() async {
    List<Entrada> list;
    try{
      list = await entradaRepo.getAll();
    } on TimeoutException{
      list = [];
    }
    return list;
  }

  Future<void> _initService() async{
    _pdfService = PDFService();
    _excelService = ExcelService();
    entradaRepo = EntradaAlimentosRepository(widget.dbContext);
    proveedorRepo = ProveedorRepository(widget.dbContext);

    await Future.wait([
      _pdfService.init(),
      _excelService.init()
    ]).then((value) => setState(() {_isLoading = false;}));

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
                            title: Text("${entrada.proveedor.nombre} / ${entrada.cantidadStr}kg\n${DateFormat("dd/MM/yyyy HH:mm").format(entrada.fecha)}"),
                            leading: Column(
                              children: [
                                const Icon(Icons.account_box_sharp),
                                Text(entrada.almacenero.nombre)
                              ],
                            ),
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
                                  onPressed: _isLoading ? null : () async {
                                    //! Se que se repite el codigo, pero es un parche rapido
                                    final entradaWithProveedor = entrada.copyWith(
                                      proveedor: await proveedorRepo.getById(entrada.proveedor.id)
                                    );                                    
                                    await _excelService.printEntradaExcel(entradaWithProveedor);
                                  },
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
                                  onPressed: _isLoading ? null : () async {
                                    final entradaWithProveedor = entrada.copyWith(
                                      proveedor: await proveedorRepo.getById(entrada.proveedor.id)
                                    );
                                    await _pdfService.printEntradaPDF(entradaWithProveedor);
                                  },
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
            else if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
            else{
              return const Center(child: Text("No hay entradas registradas por el momento"));
            }
          }
        ),
    );
  }
}