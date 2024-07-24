import 'dart:async';
import 'package:bancalcaj_app/domain/classes/result.dart';
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

  final String? idEntradaToEdit;

  const AgregarEntradaScreen({super.key, this.idEntradaToEdit});

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

  bool _isUpdatable = false;
  
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

      final Result<Object> result;

      if(_isUpdatable) {
        result = await entradaService.editarEntrada(entrada, id: widget.idEntradaToEdit!);
      }
      else {
        result = await entradaService.agregarEntrada(entrada);
      }

      if(!result.success) {
        _btnController.error();
        NotificationMessage.showErrorNotification(result.message!);
        return;
      }

      _btnController.success();
      NotificationMessage.showSuccessNotification('Entrada de alimentos registrada con exito');

      //* El proceso es para actualizar y no esta montado el context
      if(_isUpdatable && mounted){
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
        title: const Text("Entrada de alimentos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Result<Entrada?>>(
        future: entradaService.seleccionarEntrada(widget.idEntradaToEdit ?? 'null'),
        builder: (context, snapEntrada) {

          if(snapEntrada.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final entrada = snapEntrada.data!.data;
          _isUpdatable = entrada != null;

          return SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo de fecha
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DateTimeField(
                        initialValue: entrada?.fecha,
                        formFieldKey: _keyFieldFecha,
                        label: "Fecha"
                      )
                    ),
              
                    // Campo de proveedor o nombre de la organzación
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropDownWithExternalData<ProveedorView>(
                        initialValue: entrada?.proveedor?.proveedorView,
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
                        initialValue: entrada?.tiposProductos,
                        formFieldKey: _keyFieldProductos,
                        defaultCommonProducts: defaultList,
                      )
                    ),
              
                    // Comentarios
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        initialValue: entrada?.comentario,
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
                        label: Text(_isUpdatable ? 'Actualizar' : 'Registrar', style: const TextStyle(color: Colors.white)),
                        color: _isUpdatable ? Colors.blue : Colors.red,
                        proccess: _onSubmit,
                      )
                    ),
                  ],
              ),
            ),
          );
        }
      )
    );
  }
}