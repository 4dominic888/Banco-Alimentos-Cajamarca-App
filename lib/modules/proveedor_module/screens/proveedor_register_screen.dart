import 'package:bancalcaj_app/domain/classes/proveedor.dart';
import 'package:bancalcaj_app/domain/classes/ubication.dart';
import 'package:bancalcaj_app/modules/proveedor_module/widgets/ubication_form_field.dart';
import 'package:bancalcaj_app/services/db_services/data_base_service.dart';
import 'package:bancalcaj_app/shared/repositories/proveedor_repository.dart';
import 'package:bancalcaj_app/shared/repositories/type_proveedor_repository.dart';
import 'package:bancalcaj_app/shared/util/result.dart';
import 'package:flutter/material.dart';

class ProveedorRegisterScreen extends StatefulWidget {

  final int? idProveedorToEdit;
  final DataBaseService dbContext;
  const ProveedorRegisterScreen({super.key, required this.dbContext, this.idProveedorToEdit});

  @override
  State<ProveedorRegisterScreen> createState() => _ProveedorRegisterScreenState();
}

class _ProveedorRegisterScreenState extends State<ProveedorRegisterScreen> {
  
  late final ProveedorRepository _proveedorRepo;
  late final TypeProveedorRepository _typeProveedorRepo;

  final _formkey = GlobalKey<FormState>();
  final _proveedorNameKey = GlobalKey<FormFieldState>();
  final _proveedorTypeKey = GlobalKey<FormFieldState>();
  final _proveedorUbicationKey = GlobalKey<FormFieldState<Ubication>>();

  bool _onLoad = false;

  @override
  void initState() {
    super.initState();
    _proveedorRepo = ProveedorRepository(widget.dbContext);
    _typeProveedorRepo = TypeProveedorRepository(widget.dbContext);
  }

  void onSubmit() async {
    if (_formkey.currentState!.validate()) {

      setState(() => _onLoad = true);
      final Proveedor proveedor = Proveedor.toSend(
        nombre: _proveedorNameKey.currentState?.value,
        typeProveedor: _proveedorTypeKey.currentState?.value,
        ubication: _proveedorUbicationKey.currentState!.value!
      );
      late final Result<String> result;
      if(widget.idProveedorToEdit != null){
        result = await _proveedorRepo.update(widget.idProveedorToEdit!, proveedor);
      }
      else{result = await _proveedorRepo.add(proveedor);}

      setState(() => _onLoad = false);

      if(!mounted) return;
      if(result.success){
        showDialog(context: context, builder: (context) => 
          AlertDialog(
            title: const Text('Exito'),
            content: Text(result.data!),
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
          title: const Text('Error'),
          content: Text(result.message!),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Ok'))
          ],
        )
      );
    }
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
      body: FutureBuilder<Proveedor?>(
        future: _proveedorRepo.getByIdDetailed(widget.idProveedorToEdit ?? -1),
        builder: (context, snapProveedor) {
          if(snapProveedor.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
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
                      initialValue: snapProveedor.data?.nombre,
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
                    child: FutureBuilder<Iterable<TypeProveedor?>>(
                      future: _typeProveedorRepo.getAll(),
                      initialData: const [],
                      builder: (context, snapshot) {
                        if(snapshot.data != null && snapshot.data!.isNotEmpty){
                          return DropdownButtonFormField<TypeProveedor?>(
                            key: _proveedorTypeKey,
                            value: snapProveedor.data?.typeProveedor,
                            onChanged: (_) {},
                            menuMaxHeight: 280,
                            items: snapshot.data!.map<DropdownMenuItem<TypeProveedor?>>((value) =>
                              DropdownMenuItem<TypeProveedor?>(
                                value: value,
                                child: Text(value!.name),
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
                      initialData: snapProveedor.data?.ubication,
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