import 'dart:async';

import 'package:bancalcaj_app/modules/control_de_entrada/classes/proveedor.dart';
import 'package:bancalcaj_app/modules/proveedor_module/screens/proveedor_register_screen.dart';
import 'package:bancalcaj_app/services/db_services/data_base_service.dart';
import 'package:bancalcaj_app/shared/repositories/proveedor_repository.dart';
import 'package:bancalcaj_app/shared/repositories/type_proveedor_repository.dart';
import 'package:flutter/material.dart';

class ProveedorViewScreen extends StatefulWidget {
  final DataBaseService dbContext;
  const ProveedorViewScreen({super.key, required this.dbContext});
  
  @override
  State<ProveedorViewScreen> createState() => _ProveedorViewScreenState();
}

class _ProveedorViewScreenState extends State<ProveedorViewScreen> {
  
  late final ProveedorRepository proveedorRepo = ProveedorRepository(widget.dbContext);
  late final TypeProveedorRepository typeProveedorRepo = TypeProveedorRepository(widget.dbContext);
  final _singleElementLoadingController = StreamController<bool>.broadcast();
  int _selectedIndex = -1;

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
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProveedorRegisterScreen(dbContext: widget.dbContext))),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: proveedorRepo.getAll(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError || snapshot.data == null){
            return const Center(child: Text('Ha ocurrido un error al mostrar la informacion'));
          }
          if(snapshot.data!.isEmpty){
            return const Center(child: Text('Sin proveedores a mostrar'));
          }
          
          return SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return StreamBuilder<bool>(
                  stream: _singleElementLoadingController.stream,
                  builder: (context, snapshot) {
                    return ProveedorElement(
                      dbContext: widget.dbContext,
                      proveedor: item,
                      leading: StreamBuilder<bool>(
                        stream: _singleElementLoadingController.stream,
                        builder: (context, snapshot) => 
                          (snapshot.data ?? false) && _selectedIndex == index ? 
                            const CircularProgressIndicator() : 
                            IconButton(
                              onPressed: (snapshot.data != null ? !snapshot.data! : true) ? () async {
                                _singleElementLoadingController.sink.add(true); _selectedIndex = index;
                                final Proveedor detailItem = (await proveedorRepo.getByIdDetailed(item.id))!;
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
  final DataBaseService dbContext;

  const ProveedorElement({super.key, required this.proveedor, required this.dbContext, this.onTap, this.leading});

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
        onSelected: (value) {
          switch (value) {
            case 0: Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProveedorRegisterScreen(dbContext: dbContext)));
            default: return;
          }
        },
      )
    );
  }
}