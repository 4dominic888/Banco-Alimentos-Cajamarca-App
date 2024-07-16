import 'dart:async';

import 'package:bancalcaj_app/domain/models/entrada.dart';
import 'package:bancalcaj_app/domain/classes/producto.dart';
import 'package:bancalcaj_app/domain/services/entrada_alimentos_service_base.dart';
import 'package:bancalcaj_app/domain/services/proveedor_service_base.dart';
import 'package:bancalcaj_app/infrastructure/excel_writter.dart';
import 'package:bancalcaj_app/infrastructure/pdf_writter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class VerEntradasScreen extends StatefulWidget {
  const VerEntradasScreen({super.key});

  @override
  State<VerEntradasScreen> createState() => _VerEntradasScreenState();
}

class _VerEntradasScreenState extends State<VerEntradasScreen> {
  
  final entradaService = GetIt.I<EntradaAlimentosServiceBase>();
  final proveedorService = GetIt.I<ProveedorServiceBase>();

  late final PDFWritter _pdfService;
  late final ExcelWritter _excelService;
  bool _isLoading = false;

  Future<List<Entrada>> initList() async {
    final result = await entradaService.verEntradas();
    return result.data!.data;
  }

  Future<void> _initService() async{
    _pdfService = PDFWritter();
    _excelService = ExcelWritter();

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
                                    final result = await proveedorService.seleccionarProveedor(entrada.proveedor.id.toString());
                                    final entradaWithProveedor = entrada.copyWith(
                                      proveedor: result.data
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
                                    final result = await proveedorService.seleccionarProveedor(entrada.proveedor.id.toString());
                                    final entradaWithProveedor = entrada.copyWith(
                                      proveedor: result.data
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