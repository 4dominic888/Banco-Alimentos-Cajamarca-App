import 'dart:async';

import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:bancalcaj_app/domain/models/entrada.dart';
import 'package:bancalcaj_app/domain/classes/producto.dart';
import 'package:bancalcaj_app/domain/services/entrada_alimentos_service_base.dart';
import 'package:bancalcaj_app/domain/services/proveedor_service_base.dart';
import 'package:bancalcaj_app/infrastructure/excel_writter.dart';
import 'package:bancalcaj_app/infrastructure/pdf_writter.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/ver_entradas/widgets/entrada_card_element.dart';
import 'package:bancalcaj_app/presentation/widgets/pagination_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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

  int _page = 1;
  int _limit = 10;  

  Future<void> _initService() async{
    _pdfService = PDFWritter();
    _excelService = ExcelWritter();

    await Future.wait([
      _pdfService.init(),
      _excelService.init()
    ]);
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
            return ListTile(title: Text(p.nombre), subtitle: Text('${p.pesoStr} kg'));
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
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
        
        body: FutureBuilder<Result<PaginateData<EntradaView>>>(
          future: entradaService.verEntradas(pagina: _page, limite: _limit),
          builder: (context, snapshot) {

            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
            if(snapshot.hasError || snapshot.data == null){
              return Center(child: Text('Ha ocurrido un error al mostrar la informacion, ${snapshot.error}'));
            }
            if(snapshot.data!.data == null || snapshot.data!.data!.data.isEmpty){
              return const Center(child: Text('Sin entradas a mostrar'));
            }

            final currentList = snapshot.data!.data!.data; //* data data data
            final pageMetaData = snapshot.data!.data!.metadata;
            
            return Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 500,              
                  child: SingleChildScrollView(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: currentList.length,
                        itemBuilder: (context, index) { 
                          final entradaView = currentList[index];
                          return EntradaCardElement(
                            entradaView: entradaView,
                            excelService: _excelService,
                            pdfService: _pdfService
                          );
                        },
                      )
                    ),
                ),

                PaginationWidget(
                  currentPages: pageMetaData.currentPage,
                  totalPages: pageMetaData.totalPages,
                  onNextPagePressed: _page != pageMetaData.totalPages ? () => setState(() =>_page++) : null,
                  onPreviousPagePressed: _page != 1 ? () => setState(() => _page--) : null
                )

              ],
            );
          }
        ),
    );
  }
}
