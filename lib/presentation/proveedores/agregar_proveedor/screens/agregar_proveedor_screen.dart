import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/domain/classes/ubication.dart';
import 'package:bancalcaj_app/domain/services/proveedor_service_base.dart';
import 'package:bancalcaj_app/presentation/proveedores/agregar_proveedor/widgets/ubication_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AgregarProveedorScreen extends StatefulWidget {

  final String? idProveedorToEdit;
  const AgregarProveedorScreen({super.key, this.idProveedorToEdit});

  @override
  State<AgregarProveedorScreen> createState() => _AgregarProveedorScreenState();
}

class _AgregarProveedorScreenState extends State<AgregarProveedorScreen> {
  
  final proveedorService = GetIt.I<ProveedorServiceBase>();
  
  final _formkey = GlobalKey<FormState>();
  final _proveedorNameKey = GlobalKey<FormFieldState>();
  final _proveedorTypeKey = GlobalKey<FormFieldState>();
  final _proveedorUbicationKey = GlobalKey<FormFieldState<Ubication>>();

  bool _onLoad = false;

  void onSubmit() async {
    if (_formkey.currentState!.validate()) {

      setState(() => _onLoad = true);
      final Proveedor proveedor = Proveedor.toSend(
        nombre: _proveedorNameKey.currentState?.value,
        typeProveedor: _proveedorTypeKey.currentState?.value,
        ubication: _proveedorUbicationKey.currentState!.value!
      );
      final Result<Object> result;
      if(widget.idProveedorToEdit != null) {
        result = await proveedorService.editarProveedor(proveedor, id: widget.idProveedorToEdit!);
      }
      else{
        result = await proveedorService.agregarProveedor(proveedor);
      }

      setState(() => _onLoad = false);

      if(!mounted) return;
      if(!result.success){
        showDialog(context: context, builder: (context) => 
          AlertDialog(
            title: const Text('Error'),
            content: Text(result.message!),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }, child: const Text('Ok'))
            ],
          )
        );
        return;
      }
      showDialog(context: context, builder: (context) => 
        AlertDialog(
          title: const Text('Exito'),
          content: const Text('Se ha realizado el proceso con exito'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Ok'))
          ],
        )
      );
    }
  }

  Future<List<TypeProveedor>> listTypeProveedores() async {
    final result = await proveedorService.verTiposDeProveedor(limite: 20);
    if(!result.success) return [];
    return result.data!.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: const Text("Registro de proveedores"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Result<Proveedor?>> (
        future: proveedorService.seleccionarProveedor(widget.idProveedorToEdit ?? '-1'),
        builder: (context, snapProveedor) {
          if(snapProveedor.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if(snapProveedor.data != null && !snapProveedor.data!.success){
            return Center(child: Text(snapProveedor.data?.message ?? 'Nulo'));
          }
          final proveedor = snapProveedor.data!.data;
          return Form(
            key: _formkey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  //* Nombre del proveedor
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      initialValue: proveedor?.nombre,
                      key: _proveedorNameKey,
                      decoration: const InputDecoration(
                        label: Text("Nombre del proveedor"),
                        icon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if(value == null || value.trim().isEmpty){
                          return 'No se ha proporcionado un nombre';
                        }
                        value = value.trim();
                        if(value.length <= 2){
                          return 'El nombre es demasiado corto';
                        }
                        return null;
                      },
                    ),
                  ),
              
                  //* Tipo de proveedor
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    child: FutureBuilder<List<TypeProveedor>>(
                      future: listTypeProveedores(),
                      initialData: const [],
                      builder: (context, snapshot) {
                        if(snapshot.data != null && snapshot.data!.isNotEmpty){
                          return DropdownButtonFormField<TypeProveedor?>(
                            key: _proveedorTypeKey,
                            value: proveedor!.typeProveedor,
                            onChanged: (_) {},
                            menuMaxHeight: 280,
                            items: snapshot.data!.map<DropdownMenuItem<TypeProveedor?>>((value) =>
                              DropdownMenuItem<TypeProveedor?>(
                                value: value,
                                child: Text(value.name),
                              )
                            ).toList(),
                            decoration: const InputDecoration(
                              label: Text("Tipo de proveedor"),
                              icon: Icon(Icons.category)
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'No se ha seleccionado una opcion';
                              }
                              return null;
                            },
                          );
                        }
                        return const Text('No hay informacion de los tipos de proveedor');
                      }
                    )
                  ),
            
                  //* Ubicacion
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    child: UbicationFormField(
                      initialData: proveedor!.ubication,
                      formFieldKey: _proveedorUbicationKey,
                      validator: (value) {
                        if (value == null) {
                          return 'No se ha proporcionado una ubicacion completa';
                        }
                        return null;
                      },
                    )
                  ),
              
                  //* Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: !_onLoad ? onSubmit : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white
                          ),  
                          child: const Text("Registrar")
                        ),

                        const SizedBox(width: 30),
                        
                        _onLoad ? const CircularProgressIndicator(color: Colors.red) : const SizedBox.shrink()
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}