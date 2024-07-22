import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/domain/services/proveedor_service_base.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ProveedorField extends StatefulWidget {
  const ProveedorField({super.key});

  @override
  State<ProveedorField> createState() => ProveedorFieldState();
}

class ProveedorFieldState extends State<ProveedorField> {

  final proveedorService = GetIt.I<ProveedorServiceBase>();
  String? proveedorId;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<ProveedorView>(
      asyncItems: (text) async {
        final result = await proveedorService.verProveedores(pagina: 1, limite: 5, nombre: text);
        if(!result.success) return [];
        return result.data!.data;
      },
      itemAsString: (item) => item.nombre,
      validator: (value) {
        if(value == null) return 'Campo requerido';
        return null;
      },
      onChanged: (value) => proveedorId = value!.id,
    );
    // return FutureBuilder<Iterable<Proveedor>>(
    //       future: _getProveedores(),
    //       builder: (context, snapshot) {
    //         if(snapshot.hasData){
    //           return AutoCompleteField(
    //             key: _keyAutoField,
    //             title: _onAvailableConnection ? "Proveedor" : "Proveedor (sin información)",
    //             recommends: snapshot.data?.map((e) => e.nombre) ?? [],
    //             validate: (str) {
    //                 if(str == null || str.trim().isEmpty) return "El campo está vacio";
    //                 return null;
    //             },
    //           );
    //         }
    //         else{
    //           return const Column(
    //             children: [
    //               SizedBox(height: 5),
    //               SizedBox(
    //                 width: 30.0,
    //                 height: 30.0,
    //                 child: CircularProgressIndicator(
    //                   strokeWidth: 3.0,
    //                   color: Colors.red,
    //                 ),
    //               ),
    //             ],
    //           );
    //         }
    //       }
    //     );
  }
}