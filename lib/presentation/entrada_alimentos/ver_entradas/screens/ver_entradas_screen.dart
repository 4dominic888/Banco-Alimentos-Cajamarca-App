import 'dart:async';

import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:bancalcaj_app/domain/models/employee.dart';
import 'package:bancalcaj_app/domain/models/entrada.dart';
import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/domain/services/employee_service_base.dart';
import 'package:bancalcaj_app/domain/services/entrada_alimentos_service_base.dart';
import 'package:bancalcaj_app/domain/services/proveedor_service_base.dart';
import 'package:bancalcaj_app/infrastructure/excel_writter.dart';
import 'package:bancalcaj_app/infrastructure/pdf_writter.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/agregar_entrada/screens/agregar_entrada_screen.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/ver_entradas/widgets/entrada_card_element.dart';
import 'package:bancalcaj_app/presentation/widgets/big_static_size_box.dart';
import 'package:bancalcaj_app/presentation/widgets/drop_down_with_external_data.dart';
import 'package:bancalcaj_app/presentation/widgets/pagination_widget.dart';
import 'package:flutter/material.dart';
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
  final employeeService = GetIt.I<EmployeeServiceBase>();
  
  final GlobalKey<FormFieldState<ProveedorView>> _keyFieldProveedor = GlobalKey();
  final GlobalKey<FormFieldState<EmployeeView>> _keyFieldAlmacenero = GlobalKey();
  final _paginateMetadaDataController = StreamController<PaginateMetaData>();

  late final PDFWritter _pdfService;
  late final ExcelWritter _excelService;


  int _page = 1;
  int _limit = 5;
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _initService() async{
    _pdfService = PDFWritter();
    _excelService = ExcelWritter();

    await Future.wait([
      _pdfService.init(),
      _excelService.init()
    ]);
  }

  // Future<void> _showSubProducts(BuildContext context, String title, List<Producto> list){
  //   return showDialog(context: context, builder: (context) => AlertDialog(
  //     scrollable: true,
  //     title: Text(title),
  //     content: SizedBox(
  //       width: 300,
  //       height: 300,
  //       child: ListView.builder(
  //         shrinkWrap: true,
  //         itemCount: list.length,
  //         itemBuilder: (context, index) {
  //           final Producto p = list[index];
  //           return ListTile(title: Text(p.nombre), subtitle: Text('${p.pesoStr} kg'));
  //         },
  //       ),
  //     ),
  //   ));
  // }
  
  @override
  void initState() {
    super.initState();
    _initService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          title: const Text("Exportar entrada"), 
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
        
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AgregarEntradaScreen())).then((value) => setState(() { })),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add)
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    
        body: Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicWidth(
                    child: Row(
                      children: [
                    
                        //* Busqueda por proveedor
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropDownWithExternalData<ProveedorView>(
                              formFieldKey: _keyFieldProveedor,
                              itemAsString: (value) => value.nombre,
                              label: 'Proveedor',
                              isVisible: true,
                              icon: const Icon(Icons.delivery_dining),
                              asyncItems: (text) async {
                                final result = await proveedorService.verProveedores(pagina: 1, limite: 8, nombre: text);
                                if(!result.success || result.data == null) return [];
                                return result.data!.data;                              
                              },
                              onChanged: () => setState(() {})
                            )
                          )
                        ),
                    
                        //* Busqueda por almacenero
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropDownWithExternalData<EmployeeView>(
                              formFieldKey: _keyFieldAlmacenero,
                              itemAsString: (value) => value.nombre,
                              label: 'Almaceneros',
                              icon: const Icon(Icons.person),
                              isVisible: true,
                              asyncItems: (text) async {
                                final result = await employeeService.verEmpleados(pagina: 1, limite: 8, nombre: text);
                                if(!result.success || result.data == null) return [];
                                return result.data!.data;                              
                              },
                              onChanged: () => setState(() { })
                            )
                          )
                        ),
                        
                        //* Rango de fecha
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () async {
                                          final dateRange = await showDateRangePicker(
                                            context: context, 
                                            firstDate: DateTime(1850),
                                            lastDate: DateTime(3000),
                                            confirmText: "Aceptar",
                                            cancelText: "Cancelar",
                                            saveText: "Guardar",
                                            helpText: "Selecciona el rango de fechas"
                                          );
                                      
                                          if(dateRange != null){
                                            setState(() {
                                              startDate = dateRange.start;
                                              endDate = dateRange.end;
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.date_range_outlined),
                                        tooltip: "Elegir rango de fechas",
                                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.grey.shade300)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        onPressed: () => setState(() { startDate = null; endDate = null;}),
                                        icon: const Icon(Icons.cleaning_services_rounded),
                                        tooltip: "Borrar rango de fechas",
                                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red.shade100))  
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if(startDate != null && endDate != null)Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text('${DateFormat("dd/MM/yyyy").format(startDate!)} -- ${DateFormat("dd/MM/yyyy").format(endDate!)}')
                                )
                              )
                            ],
                          )
                        )
                      ],
                    )
                  ),
                ),
                  
                FutureBuilder<Result<PaginateData<EntradaView>>>(
                  future: entradaService.verEntradas(
                    pagina: _page,
                    limite: _limit,
                    proveedor: _keyFieldProveedor.currentState?.value?.id,
                    almacenero: _keyFieldAlmacenero.currentState?.value?.dni,
                    startDate: startDate,
                    endDate: endDate
                  ),
                  builder: (context, snapshot) {
                
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return BigStaticSizeBox(context, child: const Center(child: CircularProgressIndicator()));
                    }
                    if(snapshot.hasError || snapshot.data == null){
                      return BigStaticSizeBox(context, child: Center(child: Text('Ha ocurrido un error al mostrar la informacion, ${snapshot.error}')));
                    }
                    if(!snapshot.data!.success){
                      return BigStaticSizeBox(context, child: Center(child: Text(snapshot.data!.message!)));
                    }                    
                    if(snapshot.data!.data == null || snapshot.data!.data!.data.isEmpty){
                      return BigStaticSizeBox(context, child: const Center(child: Text('Sin entradas a mostrar')));
                    }
                
                    final currentList = snapshot.data!.data!.data; //* data data data
                    _paginateMetadaDataController.add(snapshot.data!.data!.metadata);
                    
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          BigStaticSizeBox(context, child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: currentList.length,
                            itemBuilder: (context, index) { 
                              final entradaView = currentList[index];
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child:LayoutBuilder(
                                  builder: (lcontext, _) {
                                    return SizedBox(
                                      width: MediaQuery.of(lcontext).size.width,
                                      child: EntradaCardElement(
                                        entradaView: entradaView,
                                        excelService: _excelService,
                                        pdfService: _pdfService,
                                        onDataUpdate: () => setState(() { }),
                                      ),
                                    );
                                  }
                                ),
                              );
                            },
                          )),
                        ],
                      ),
                    );
                  }
                ),
                  
                StreamBuilder<PaginateMetaData>(
                  stream: _paginateMetadaDataController.stream,
                  builder: (context, snapshot) {
                    return PaginationWidget(
                      currentPages: snapshot.data?.currentPage ?? 1,
                      onNextPagePressed: _page != (snapshot.data?.totalPages ?? 1) ? () => setState(() => _page++) : null,
                      totalPages: snapshot.data?.totalPages ?? 1,
                      onPreviousPagePressed: _page != 1 ? () => setState(() => _page--) : null
                    );
                  }
                )
              ],
            ),
          ),
        ),
    );
  }

  @override
  void dispose() {
    _pdfService.dispose();
    super.dispose();
  }  
}
