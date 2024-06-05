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
      body: FutureBuilder(
        future: proveedorRepo.getAll(),
        builder: (context, snapshot) {
          if(snapshot.hasError || snapshot.data == null){
            return const Center(child: Text('Ha ocurrido un error al mostrar la informacion'));
          }
          if(snapshot.data!.isEmpty){
            return const Center(child: Text('Sin proveedores a mostrar'));
          }
          return SingleChildScrollView(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return ListTile(
                  title: Text(item.nombre),
                  subtitle: Text(item.ubication.type),
                );
              },
            ),
          );
        }
      ),
    );
  }
}