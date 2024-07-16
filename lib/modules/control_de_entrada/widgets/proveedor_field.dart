import 'dart:async';
import 'dart:io';

import 'package:bancalcaj_app/modules/control_de_entrada/classes/proveedor.dart';
import 'package:bancalcaj_app/shared/repositories/proveedor_repository.dart';
import 'package:bancalcaj_app/services/db_services/data_base_service.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';

class ProveedorField extends StatefulWidget {
  final DataBaseService dbContext;
  const ProveedorField({super.key, required this.dbContext});

  @override
  State<ProveedorField> createState() => ProveedorFieldState();
}

class ProveedorFieldState extends State<ProveedorField> {

  late final ProveedorRepository proveedorRepo;

  late final TextEditingController _dropDownSearchController;
  Proveedor? proveedor;

  Future<List<Proveedor>> _getProveedores(String? search) async{
    final paginateData = search == null ? 
      await proveedorRepo.getAllPaginated(limit: 20) : await proveedorRepo.getAllPaginated(search: search, limit: 20);
      
    print(paginateData!.data);
    return paginateData!.data;
  }

  @override
  void initState() {
    super.initState();
    proveedorRepo = ProveedorRepository(widget.dbContext);
    _dropDownSearchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return DropDownSearchField<Proveedor>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _dropDownSearchController,
        decoration: const InputDecoration(
          labelText: 'Proveedor'
        )
      ),
      errorBuilder: (context, error) => 
        ExpansionTile(
          title: const Text('Se ha producido un error',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red)
          ),
          subtitle: Text('Ha ocurrido un error de conexion: ${(error as SocketException).message}', style: const TextStyle(color: Colors.red)),
        ),
      
      suggestionsCallback: (pattern) => _getProveedores(pattern),
      itemBuilder: (context, itemData) => ListTile(title: Text(itemData.nombre)),
      transitionBuilder: (context, suggestionsBox, controller) => suggestionsBox,
      loadingBuilder: (context) => const ListTile(leading: CircularProgressIndicator(color: Colors.red)),
      noItemsFoundBuilder: (context) => const ListTile(title: Text('Proveedores no encontrados...', style: TextStyle(fontWeight: FontWeight.bold)), contentPadding: EdgeInsets.only(left: 20)),
      onSuggestionSelected: (suggestion){
        proveedor = suggestion;
        _dropDownSearchController.text = suggestion.nombre;
      },
      displayAllSuggestionWhenTap: true
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