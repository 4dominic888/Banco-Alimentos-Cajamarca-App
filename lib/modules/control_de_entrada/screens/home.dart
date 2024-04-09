import 'package:bancalcaj_app/modules/control_de_entrada/classes/almacenero.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/classes/entrada.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/widgets/datetime_field.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/widgets/decimal_field.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/widgets/select_multiple_field.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/widgets/validate_text_field.dart';
import 'package:flutter/material.dart';

class ControlEntradaScreen extends StatefulWidget {
  const ControlEntradaScreen({super.key});

  @override
  State<ControlEntradaScreen> createState() => _ControlEntradaScreenState();
}

class _ControlEntradaScreenState extends State<ControlEntradaScreen> {

  final formkey = GlobalKey<FormState>();

  final GlobalKey<DateTimeFieldState> _keyFieldFecha = GlobalKey();
  final GlobalKey<DecimalFieldState> _keyFieldCantidad = GlobalKey();
  final GlobalKey<SelectMultipleFieldState> _keyFieldProductos = GlobalKey();
  final GlobalKey<ValidateTextFieldState> _keyFieldProveedor = GlobalKey();
  final GlobalKey<FormFieldState> _keyFieldComentario = GlobalKey();

  //TODO El almacenero deberia ser el usuario de la aplicacion.
  final Almacenero almacenero = Almacenero(nombre: "nombre", DNI: "96541245", firma: "...");
  
  //TODO: La lista deberia llamarse de alguna base de datos o similar, de momento esto sirve para testear.
  List<String> defaultList = ["Carne", "Fruta", "Verdura", "Abarrote", "Embutido"];

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

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            title: const Text("Entrada de alimentos"),
          ),
          body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            
                  // Campo de fecha
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DateTimeField(key: _keyFieldFecha, label: "Fecha")
                  ),
            
            
                  // Campo de cantidad en kg
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DecimalField(key: _keyFieldCantidad, label: "Cantidad", suffixText: "Kg", emtpyValidate: "La cantidad no ha sido ingresada")
                  ),
            

                  // Campo de proveedor o nombre de la organzación
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ValidateTextField(
                      key: _keyFieldProveedor,
                      title: "Proveedor (Nombre de la organización)",
                      emtpyValidate: "El proveedor no ha sido ingresado",
                    ),
                  ),
            
                  // Campo de tipo de producto
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SelectMultipleField(
                      key: _keyFieldProductos,
                      label: "Tipo de productos",
                      hintModalCustom: 'Ingrese el nomnbre del producto',
                      hintSelectElements: 'Seleccione los productos',
                      titleModalCustom: 'Agregar un producto extra',
                      list: defaultList,
                      emtpyValidate: "Se debe seleccionar al menos un tipo de producto",
                    ),
                  ),
            
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      key: _keyFieldComentario,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(label: Text("Comentarios u observaciones a tener en cuenta")),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        StringBuffer errorText = StringBuffer();
                        final fechaState = _keyFieldFecha.currentState!;
                        final cantidadState = _keyFieldCantidad.currentState!;
                        final proveedorState = _keyFieldProveedor.currentState!;
                        final productosState = _keyFieldProductos.currentState!;
                        final comentarioState = _keyFieldComentario.currentState!;

                        errorText.write(cantidadState.validator);
                        errorText.write(proveedorState.validator);
                        errorText.write(productosState.validator);

                        if(errorText.isNotEmpty) { //* Si hay al menos un error
                          _showAlert(
                            context,
                            title: "Ha ocurrido un error",
                            content: errorText.toString(),
                            onPressed: () => Navigator.of(context).pop(),
                          );
                        }
                        else{
                          _showAlert(
                            context,
                            title: "Exito",
                            content: "Se ha registrado la entrada de alimentos correctamente",
                            onPressed: () {
                              Navigator.of(context).pop();
                              // api a excel drive
                              //TODO limpiar los campos
                            },
                          );
                        }


                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white
                      ),
                      child: const Text("Registrar"),
                    ),
                  ),                  
                ],
            ),
          )
        );
  }
}