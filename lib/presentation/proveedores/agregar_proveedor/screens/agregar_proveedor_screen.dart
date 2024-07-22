import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/domain/classes/ubication.dart';
import 'package:bancalcaj_app/domain/services/proveedor_service_base.dart';
import 'package:bancalcaj_app/presentation/widgets/drop_down_with_external_data.dart';
import 'package:bancalcaj_app/presentation/proveedores/agregar_proveedor/widgets/ubication_form_field.dart';
import 'package:bancalcaj_app/presentation/widgets/loading_process_button.dart';
import 'package:bancalcaj_app/presentation/widgets/notification_message.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

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

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  
  Future<void> onSubmit() async {
    if (_formkey.currentState!.validate()) {
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
      if(!result.success){
        _btnController.error();
        NotificationMessage.showErrorNotification(title: 'Error', description: result.message!);
        return;
      }

      _btnController.success();
      NotificationMessage.showSuccessNotification(title: 'Exito', description: 'Se ha realizado el proceso con exito');

      //* El proceso es para actualizar y no esta montado el context
      if(widget.idProveedorToEdit != null && mounted){
        Navigator.of(context).pop();
      }

      return;
    }
    _btnController.error();
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
                    child: DropDownWithExternalData<TypeProveedor>(
                      formFieldKey: _proveedorTypeKey,
                      initialValue: proveedor?.typeProveedor,
                      itemAsString: (TypeProveedor value) => value.name,
                      icon: const Icon(Icons.category),
                      label: 'Tipo de proveedor',
                      asyncItems: (text) async {
                        final result = await proveedorService.verTiposDeProveedor(pagina: 1, limite: 8, nombre: text);
                        if(!result.success) return [];
                        return result.data!.data;
                      },
                    ),
                  ),
            
                  //* Ubicacion
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    child: UbicationFormField(
                      initialData: proveedor?.ubication,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    child: LoadingProcessButton(
                      controller: _btnController,
                      label: Text(
                        widget.idProveedorToEdit != null ? 'Actualizar' : 'Registrar',
                        style: const TextStyle(color: Colors.white)
                      ),
                      color: Colors.red,
                      proccess: onSubmit,
                    )
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
