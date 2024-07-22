import 'dart:async';
import 'package:bancalcaj_app/domain/models/entrada.dart';
import 'package:bancalcaj_app/domain/classes/producto.dart';
import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/domain/services/entrada_alimentos_service_base.dart';
import 'package:bancalcaj_app/domain/services/proveedor_service_base.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/agregar_entrada/widgets/select_products.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/agregar_entrada/widgets/datetime_field.dart';
import 'package:bancalcaj_app/presentation/widgets/drop_down_with_external_data.dart';
import 'package:bancalcaj_app/presentation/widgets/loading_process_button.dart';
import 'package:bancalcaj_app/presentation/widgets/notification_message.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class AgregarEntradaScreen extends StatefulWidget {
  const AgregarEntradaScreen({super.key});

  @override
  State<AgregarEntradaScreen> createState() => _AgregarEntradaScreenState();
}

class _AgregarEntradaScreenState extends State<AgregarEntradaScreen> {

  final formkey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState<DateTime>> _keyFieldFecha = GlobalKey();
  final GlobalKey<FormFieldState<ProveedorView>> _keyFieldProveedor = GlobalKey();
  final GlobalKey<FormFieldState<List<TipoProductos>>> _keyFieldProductos = GlobalKey();
  final GlobalKey<FormFieldState> _keyFieldComentario = GlobalKey();

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  final entradaService = GetIt.I<EntradaAlimentosServiceBase>();
  final proveedorService = GetIt.I<ProveedorServiceBase>();
  
  //TODO: La lista deberia llamarse de alguna base de datos o similar, de momento esto sirve para testear.
  List<String> defaultList = ["Carnes", "Frutas", "Verduras", "Abarrotes", "Embutidos"];

  Future<void> _onSubmit() async{
    if(formkey.currentState!.validate()) {

      final DateTime fecha = _keyFieldFecha.currentState!.value!;
      final ProveedorView proveedorView = _keyFieldProveedor.currentState!.value!;
      final List<TipoProductos> productos = _keyFieldProductos.currentState!.value!;
      final String comentario = _keyFieldComentario.currentState?.value as String? ?? '';
      final cantidad = productos.sumBy((lp) => lp.productos.sumBy((p) => p.peso));

      final entrada = Entrada.reduced(
        fecha: fecha,
        proveedorId: proveedorView.id,
        tiposProductos: productos,
        cantidad: cantidad,
        almaceneroId: '12345678',
        comentario: comentario
      );

      final result = await entradaService.agregarEntrada(entrada);
      if(!result.success) {
        NotificationMessage.showErrorNotification(title: 'Error', description: result.message!);
        _btnController.error();
        return;
      }

      NotificationMessage.showSuccessNotification(title: 'Exito', description: 'Entrada de alimentos registrada con exito');
      _btnController.success();
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
        title: const Text("Entrada de alimentos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campo de fecha
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DateTimeField(formFieldKey: _keyFieldFecha, label: "Fecha")
                ),
          
                // Campo de proveedor o nombre de la organzación
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropDownWithExternalData<ProveedorView>(
                    formFieldKey: _keyFieldProveedor,
                    itemAsString: (value) => value.nombre,
                    label: 'Proveedor',
                    icon: const Icon(Icons.delivery_dining),
                    asyncItems: (text) async {
                      final result = await proveedorService.verProveedores(pagina: 1, limite: 8, nombre: text);
                      if(!result.success || result.data == null) return [];
                      return result.data!.data;
                    },
                  )
                ),
          
                // Campo de selección de productos
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SelectProductsField(
                    formFieldKey: _keyFieldProductos,
                    defaultCommonProducts: defaultList,
                  )
                ),
          
                // Comentarios
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    key: _keyFieldComentario,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      label: Text("Comentarios u observaciones a tener en cuenta"),
                      prefixIcon: Icon(Icons.comment)
                    ),
                  ),
                ),

                // Submit button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  child: LoadingProcessButton(
                    controller: _btnController,
                    label: const Text('Registrar', style: TextStyle(color: Colors.white)),
                    color: Colors.red,
                    proccess: _onSubmit,
                  )
                ),
              ],
          ),
        ),
      )
    );
  }
}