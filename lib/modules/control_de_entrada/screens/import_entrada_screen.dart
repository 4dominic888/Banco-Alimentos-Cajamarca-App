import 'dart:async';
import 'dart:io';

import 'package:bancalcaj_app/modules/control_de_entrada/classes/almacenero.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/entrada.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/producto.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/widgets/proveedor_field.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/widgets/select_products.dart';

import 'package:bancalcaj_app/shared/repositories/entrada_alimentos_repository.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/widgets/datetime_field.dart';

import 'package:bancalcaj_app/services/db_services/data_base_service.dart';
import 'package:flutter/material.dart';

class ImportEntradaScreen extends StatefulWidget {
  const ImportEntradaScreen({super.key, required this.dbContext});
  final DataBaseService dbContext;

  @override
  State<ImportEntradaScreen> createState() => _ImportEntradaScreenState();
}

class _ImportEntradaScreenState extends State<ImportEntradaScreen> {

  final formkey = GlobalKey<FormState>();

  final GlobalKey<DateTimeFieldState> _keyFieldFecha = GlobalKey();
  final GlobalKey<ProveedorFieldState> _keyFieldProveedor = GlobalKey();
  final GlobalKey<SelectProductsFieldState> _keyFieldProductos = GlobalKey();
  final GlobalKey<FormFieldState> _keyFieldComentario = GlobalKey();

  late final EntradaAlimentosRepository entradaRepo;
  bool _onLoad = false;
  
  //TODO: La lista deberia llamarse de alguna base de datos o similar, de momento esto sirve para testear.
  List<String> defaultList = ["Carnes", "Frutas", "Verduras", "Abarrotes", "Embutidos"];

  Future _showAlert(BuildContext context, {required String title, required String content, void Function()? onPressed}){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: (){
            onPressed?.call();
            Navigator.of(context).pop();
          }, child: const Text("Ok"))
        ],
      );
    });
  }

  Future _showAlertChoice(BuildContext context, {required String title, required String content, required void Function() onYes, required void Function() onNo}){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: (){
            onYes.call();
            Navigator.of(context).pop();
          }, child: const Text("Aceptar")),
          TextButton(onPressed: (){
            onNo.call();
            Navigator.of(context).pop();
          }, child: const Text("Cancelar"))
        ],
      );
    });
  }

  Future<void> _onSubmit() async{

    final fecha = _keyFieldFecha.currentState!.fecha;
    final cantidad = _keyFieldProductos.currentState!.cantidadTotal;
    final proveedor = _keyFieldProveedor.currentState!.proveedor;
    final productos = _keyFieldProductos.currentState!.listProducts;
    final comentario = _keyFieldComentario.currentState!.value.toString();

    if(formkey.currentState!.validate()){
      final List<TipoProductos> tiposProductos = [];
      productos.forEach((key, value) {
        tiposProductos.add(
          TipoProductos(
            nombre: key,
            productos: value
          )
        );
      });

      if(proveedor.id == "0"){
        await _showAlert(
          context, 
          title: "Advertencia",
          content: "El proveedor ingresado no está registrado actualmente, ¿Desea registrar dicho proveedor de todas maneras?",
        );
      }

      await _registerEntrada(Entrada(
        fecha: fecha,
        cantidad: cantidad,
        proveedor: proveedor,
        productos: tiposProductos,
        comentario: comentario,
        almacenero: Almacenero(nombre: "almacenero test", dni: "12345678")
      ));
    }
  }

  Future<void> _registerEntrada(Entrada e) async{
    setState(() {
      _onLoad = true;
    });
    try{
      await entradaRepo.add(e).then((value) {
        setState(() {
          _onLoad = false;
        });      
        _showAlert(context, 
          title: "Exito",
          content: "Se ha registrado la entrada de alimentos correctamente",
          onPressed: () async {
            //TODO limpiar los campos
          });
      });
    } on HttpException catch (exception){
      setState(() {
        _onLoad = false;
      });
      _showAlert(
        context,
        title: 'Ha ocurrido un error con el servidor',
        content: exception.message,
      );
    } on FormatException catch (exception){
      setState(() {
        _onLoad = false;
      });   
      _showAlert(
        context,
        title: 'Ha ocurrido un error interno',
        content: exception.message,
      );
    } on TimeoutException{
      setState(() {
        _onLoad = false;
      });   
      _showAlert(
        context,
        title: 'Ha ocurrido un error de conexión',
        content: "Verifique su conexión a internet o el estado del servidor e inténtelo nuevamente",
      );      
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    entradaRepo = EntradaAlimentosRepository(widget.dbContext);
    super.initState();
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
                      child: DateTimeField(key: _keyFieldFecha, label: "Fecha")
                    ),
              
              
                    // Campo de proveedor o nombre de la organzación
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ProveedorField(key: _keyFieldProveedor, dbContext: widget.dbContext)
                    ),
              
                    // Campo de selección de productos
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SelectProductsField(
                        key: _keyFieldProductos,
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
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async => await _onSubmit(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white
                            ),
                            child: const Text("Registrar"),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: _onLoad ? const CircularProgressIndicator() : const SizedBox.shrink()
                          )
                        ],
                      ),
                    ),
                  ],
              ),
            ),
          )
        );
  }
}