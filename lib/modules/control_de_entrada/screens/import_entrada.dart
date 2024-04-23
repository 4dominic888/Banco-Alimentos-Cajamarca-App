import 'package:bancalcaj_app/modules/control_de_entrada/classes/entrada.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/proveedor.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/repositories/proveedor_repository.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/widgets/auto_completed_field.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/widgets/select_products.dart';

import 'package:bancalcaj_app/modules/control_de_entrada/repositories/entrada_alimentos_repository.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/widgets/datetime_field.dart';

import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';
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
  final GlobalKey<AutoCompleteFieldState> _keyFieldProveedor = GlobalKey();
  final GlobalKey<SelectProductsFieldState> _keyFieldProductos = GlobalKey();
  final GlobalKey<FormFieldState> _keyFieldComentario = GlobalKey();

  late final EntradaAlimentosRepository entradaRepo;
  late final ProveedorRepository proveedorRepo;
  bool _onLoad = false;
  
  //TODO: La lista deberia llamarse de alguna base de datos o similar, de momento esto sirve para testear.
  List<String> defaultList = ["Carnes", "Frutas", "Verduras", "Abarrotes", "Embutidos"];

  Future _showAlert(BuildContext context, {required String title, required String content, required void Function() onPressed}){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: onPressed, child: const Text("Ok"))
        ],
      );
    });
  }

  Future _onSubmit() async{

    final fecha = _keyFieldFecha.currentState!.fecha;
    final cantidad = _keyFieldProductos.currentState!.cantidadTotal;
    final proveedor = _keyFieldProveedor.currentState!.text;
    final productos = _keyFieldProductos.currentState!.listProducts;
    final comentario = _keyFieldComentario.currentState!.value.toString();

    if(formkey.currentState!.validate()){
      /*
      final Entrada p = Entrada(
        fecha: fecha,
        cantidad: cantidad,
        proveedor: proveedor,
        productos: productos,
        comentario: comentario
      );
      
      entradaRepo.add(p);
      */
      
    }

    /* //? codigo para validar que el dato ha sido registrado a la bd, para cambiar
      entradaRepo.add(data).then(
        (value){
          _showAlert(
            context,
            title: "Exito",
            content: "Se ha registrado la entrada de alimentos correctamente ${value.toString()}",
            onPressed: () async {
              Navigator.of(context).pop();
              //TODO limpiar los campos
            },
          );
        }
      ).catchError((error){
        if(error is http.ClientException){
          _showAlert(context, title: "Error", content: "Compruebe su conexión a internet e inténtelo nuevamente", onPressed: ()=>Navigator.of(context).pop());
        }
      }).whenComplete(() {
        setState(() {
          _onLoad = false;
        });
      });
      */
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    entradaRepo = EntradaAlimentosRepository(widget.dbContext);
    proveedorRepo = ProveedorRepository(widget.dbContext);
    super.initState();
  }

  Future<List<String>> getProveedores() async{
    final list = await proveedorRepo.getAll() ?? [];
    return list.map((e) => e.nombre).toList();
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
                      child: FutureBuilder<List<String>>(
                        future: getProveedores(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            return AutoCompleteField(
                              key: _keyFieldProveedor,
                              title: "Proveedor",
                              recommends: snapshot.data ?? [],
                            );
                          }
                          else{
                            return const CircularProgressIndicator();
                          }
                        }
                      ),
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
                            onPressed: _onSubmit,
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