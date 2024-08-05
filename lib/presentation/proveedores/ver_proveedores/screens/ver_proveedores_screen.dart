import 'dart:async';

import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/domain/services/proveedor_service_base.dart';
import 'package:bancalcaj_app/presentation/proveedores/agregar_proveedor/screens/agregar_proveedor_screen.dart';
import 'package:bancalcaj_app/presentation/widgets/big_static_size_box.dart';
import 'package:bancalcaj_app/presentation/widgets/drop_down_with_external_data.dart';
import 'package:bancalcaj_app/presentation/widgets/pagination_widget.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:bancalcaj_app/presentation/proveedores/ver_proveedores/widgets/proveedor_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class VerProveedoresScreen extends StatefulWidget {
  const VerProveedoresScreen({super.key});
  
  @override
  State<VerProveedoresScreen> createState() => _VerProveedoresScreenState();
}

class _VerProveedoresScreenState extends State<VerProveedoresScreen> {
  
  final proveedorService = GetIt.I<ProveedorServiceBase>();

  //* Para seleccion
  final _singleElementLoadingController = StreamController<bool>.broadcast();
  final _paginateMetadaDataController = StreamController<PaginateMetaData>();

  final GlobalKey<FormFieldState<TypeProveedor>> _keyFieldTypeProveedor = GlobalKey();
  final _nameController = TextEditingController();

  int _selectedIndex = -1;
  int _page = 1;
  int _limit = 8;

  void showProveedorDetail(Proveedor detailItem) async{
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text(detailItem.nombre),
      content: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(detailItem.typeProveedor?.name ?? '-'),
            Text('Pais: ${detailItem.ubication.getCountryName ?? 'unknown'}'),
            
            detailItem.ubication.subPlaces!.isNotEmpty ? Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                InputChip(onPressed: (){}, label: Text('Departamento: ${detailItem.ubication.getDepartamentoName!}'), ),
                InputChip(onPressed: (){}, label: Text('Provincia: ${detailItem.ubication.getProvinciaName!}')),
                InputChip(onPressed: (){}, label: Text('Distrito: ${detailItem.ubication.getDistritoName!}'))
            ]) : const SizedBox.shrink()
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: { const SingleActivator(LogicalKeyboardKey.escape) : Navigator.of(context).pop },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          title: const Text("Lista de proveedores"), 
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AgregarProveedorScreen())).then((value) => setState(() { })),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Focus(
          autofocus: true,
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(icon: Icon(Icons.search), hintText: 'Buscar por nombre'),
                              onChanged: (value) => setState(() { }),
                            )
                          )
                        ),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropDownWithExternalData<TypeProveedor>(
                            formFieldKey: _keyFieldTypeProveedor,
                            itemAsString: (value) => value.name,
                            label: 'Tipo de proveedor',
                            isVisible: true,
                            icon: const Icon(Icons.category),
                            asyncItems: (text) async {
                              final result = await proveedorService.verTiposDeProveedor(pagina: 1, limite: 8, nombre: text);
                              if(!result.success || result.data == null) return [];
                              return result.data!.data;                              
                            },
                            onChanged: () => setState(() {})                    
                          ),
                        ))
                      ],
                    ),
                  ),
                    
                  FutureBuilder<Result<PaginateData<ProveedorView>>?>(
                    future: proveedorService.verProveedores(pagina: _page, limite: _limit, nombre: _nameController.text, tipoProveedor: _keyFieldTypeProveedor.currentState?.value?.name),
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
                        return BigStaticSizeBox(context, child: const Center(child: Text('Sin proveedores a mostrar')));
                      }
                      final currentList = snapshot.data!.data!.data; //* data data data
                      _paginateMetadaDataController.add(snapshot.data!.data!.metadata);
                      
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BigStaticSizeBox(context,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: currentList.length,
                              itemBuilder: (context, index) {
                                final item = currentList[index];
                                return StreamBuilder<bool>(
                                  stream: _singleElementLoadingController.stream,
                                  builder: (context, singleSnapshot) {
                                    return ProveedorElement(
                                      proveedor: item,
                                      onDataUpdate: () => setState(() { }),
                                      leading: StreamBuilder<bool>(
                                        stream: _singleElementLoadingController.stream,
                                        builder: (context, streamSnapshot) => 
                                          (streamSnapshot.data ?? false) && _selectedIndex == index ? 
                                            const CircularProgressIndicator() : 
                                            IconButton(
                                              onPressed: (streamSnapshot.data != null ? !streamSnapshot.data! : true) ? () async {
                                                _singleElementLoadingController.sink.add(true); _selectedIndex = index;
                                                final result = await proveedorService.seleccionarProveedor(item.id);
                                                if(!result.success) {
                                                  // TODO dialog
                                                  return;
                                                }
                                                await result.data!.ubication.fillFields();
                                                _singleElementLoadingController.sink.add(false);
                                                if(!context.mounted) return;
                                                showProveedorDetail(result.data!);
                                              } : null,
                                              icon: const Icon(Icons.remove_red_eye_rounded)
                                            )
                                        
                                      ),
                                    );
                                  }
                                );
                              },
                            ),
                          ),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _singleElementLoadingController.close();
    _paginateMetadaDataController.close();
    _nameController.dispose();
    super.dispose();
  }
}