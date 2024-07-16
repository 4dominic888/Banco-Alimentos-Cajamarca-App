import 'dart:async';

import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/domain/services/proveedor_service_base.dart';
import 'package:bancalcaj_app/presentation/proveedores/agregar_proveedor/screens/agregar_proveedor_screen.dart';
import 'package:bancalcaj_app/presentation/proveedores/ver_proveedores/widgets/pagination_widget.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class VerProveedoresScreen extends StatefulWidget {
  const VerProveedoresScreen({super.key});
  
  @override
  State<VerProveedoresScreen> createState() => _VerProveedoresScreenState();
}

class _VerProveedoresScreenState extends State<VerProveedoresScreen> {
  
  final proveedorService = GetIt.I<ProveedorServiceBase>();
  final _singleElementLoadingController = StreamController<bool>.broadcast();
  int _selectedIndex = -1;

  int _page = 1;
  int _limit = 10;

  void showProveedorDetail(Proveedor detailItem) async{
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text(detailItem.nombre),
      content: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(detailItem.typeProveedor.name),
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
    return Scaffold(
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
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AgregarProveedorScreen())),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: FutureBuilder<Result<PaginateData<Proveedor>>?>(
        future: proveedorService.verProveedores(pagina: _page, limite: _limit),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError || snapshot.data == null){
            return Center(child: Text('Ha ocurrido un error al mostrar la informacion, ${snapshot.error}'));
          }
          if(snapshot.data!.data == null || snapshot.data!.data!.data.isEmpty){
            return const Center(child: Text('Sin proveedores a mostrar'));
          }
          final paginateData = snapshot.data!.data!;
          final currentList = paginateData.data;
          final pageMetaData = paginateData.metadata;
          
          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 500,
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
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
                            leading: StreamBuilder<bool>(
                              stream: _singleElementLoadingController.stream,
                              builder: (context, streamSnapshot) => 
                                (streamSnapshot.data ?? false) && _selectedIndex == index ? 
                                  const CircularProgressIndicator() : 
                                  IconButton(
                                    onPressed: (streamSnapshot.data != null ? !streamSnapshot.data! : true) ? () async {
                                      _singleElementLoadingController.sink.add(true); _selectedIndex = index;
                                      final Proveedor detailItem = (await proveedorService.seleccionarProveedor(item.id)).data!;
                                      _singleElementLoadingController.sink.add(false);
                                      if(!context.mounted) return;
                                      showProveedorDetail(detailItem);
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

class ProveedorElement extends StatelessWidget {

  final Proveedor proveedor;
  final void Function()? onTap;
  final Widget? leading;

  const ProveedorElement({super.key, required this.proveedor, this.onTap, this.leading});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(proveedor.nombre),
      subtitle: Text(proveedor.typeProveedor.name),
      onTap: onTap,
      leading: leading,
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(value: 0, child: Text('Editar'),)
        ],
        onSelected: (value) async {
          switch (value) {
            case 0: Navigator.of(context).push(MaterialPageRoute(builder: (context) => AgregarProveedorScreen(
              idProveedorToEdit: proveedor.id,
            )));
            default: return;
          }
        },
      )
    );
  }
}