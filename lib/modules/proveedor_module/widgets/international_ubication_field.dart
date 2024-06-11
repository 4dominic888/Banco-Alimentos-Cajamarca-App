import 'dart:io';

import 'package:bancalcaj_app/modules/proveedor_module/classes/international_ubication.dart';
import 'package:bancalcaj_app/modules/proveedor_module/classes/ubication.dart';
import 'package:bancalcaj_app/modules/proveedor_module/widgets/controllers/ubication_field_controller.dart';
import 'package:bancalcaj_app/services/api_readonly_services/ubication_api.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';

class InternationalUbicationField extends StatefulWidget {
  
  final UbicationFieldController? controller;
  final Ubication? initialData;
  const InternationalUbicationField({super.key, this.controller, this.initialData});

  @override
  State<InternationalUbicationField> createState() => _InternationalUbicationFieldState();
}

class _InternationalUbicationFieldState extends State<InternationalUbicationField> {

  late final TextEditingController _dropDownSearchController;
  String _selectedCountry = '';
  String _selectedIndex = '';
  
  @override
  void initState() {
    super.initState();
    if(widget.initialData != null){
      _selectedIndex = widget.initialData!.countryCode;
      _selectedCountry = widget.initialData!.getCountryName!;
      _dropDownSearchController = TextEditingController(text: _selectedCountry);
      return;
    }
    _dropDownSearchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return DropDownSearchField<Map<String,String>>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _dropDownSearchController,
        decoration: const InputDecoration(
          labelText: 'Pais'
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
      suggestionsCallback: (pattern) => UbicationAPI.paises(pattern).then((value) => value.data!),
      itemBuilder: (context, itemData) => ListTile(title: Text(itemData['nombre']!)),
      transitionBuilder: (context, suggestionsBox, controller) => suggestionsBox,
      loadingBuilder: (context) => const ListTile(leading: CircularProgressIndicator(color: Colors.red)),
      noItemsFoundBuilder: (context) => const ListTile(title: Text('Paises no encontrados...', style: TextStyle(fontWeight: FontWeight.bold)), contentPadding: EdgeInsets.only(left: 20)),
      onSuggestionSelected: (suggestion) {
        _selectedCountry = suggestion['nombre']!;
        _dropDownSearchController.text = _selectedCountry;
        _selectedIndex = suggestion['codigo']!;

        widget.controller?.setValue = InternationalUbication({'codigo':_selectedIndex, 'nombre':_selectedCountry}, [
          //* subplaces futuros
        ]);
      },
      displayAllSuggestionWhenTap: true,
    );
  }

  @override
  void dispose() {
    _dropDownSearchController.dispose();
    super.dispose();
  }
}