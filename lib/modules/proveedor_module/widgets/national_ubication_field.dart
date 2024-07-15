import 'dart:async';

import 'package:bancalcaj_app/modules/proveedor_module/classes/national_ubication.dart';
import 'package:bancalcaj_app/modules/proveedor_module/classes/ubication.dart';
import 'package:bancalcaj_app/modules/proveedor_module/widgets/controllers/ubication_field_controller.dart';
import 'package:bancalcaj_app/services/api_readonly_services/ubication_api.dart';
import 'package:flutter/material.dart';

class NationalUbicationField extends StatefulWidget {

  final UbicationFieldController? controller;
  final Ubication? initialData;
  const NationalUbicationField({super.key, this.controller, this.initialData});

  @override
  State<NationalUbicationField> createState() => _NationalUbicationFieldState();
}

class _NationalUbicationFieldState extends State<NationalUbicationField> {
  Widget _defaultDropDown(String title){
    return DropdownButtonFormField(
      items: const [],
      onChanged: (_){},
      hint: const Text('Sin informacion...'),
      decoration: InputDecoration(
        label: Text(title),
        icon: const Icon(Icons.location_on)
      )
    );
  }

  Widget _normalDropDown(String title, AsyncSnapshot<List<Map<String, String?>>> snapshot, void Function(String?)? onChanged, [String? initialValue]){
    return DropdownButtonFormField<String>(
      onChanged: onChanged,
      menuMaxHeight: 280,
      value: initialValue,
      items: snapshot.data?.map<DropdownMenuItem<String>>((value) =>
        DropdownMenuItem<String>(
          value: value["codigo"],
          child: Text(value["nombre"] as String),
        )
      ).toList(),
      decoration: InputDecoration(
        label: Text(title),
        icon: snapshot.connectionState == ConnectionState.waiting ? 
          const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.red)) :
          const Icon(Icons.location_on)
      ),
    );
  }

  String? codigoDepartamento;
  String? codigoProvincia;
  String? codigoDistrito;

  final _provinciaController = StreamController<List<Map<String, String?>>>();
  final _distritoController = StreamController<List<Map<String, String?>>>();

  late Future<List<Map<String, String>>> _departamentosList;

  @override
  void initState() {
    super.initState();
    _departamentosList = UbicationAPI.departamentos.then((value) => value.data ?? []);
    _preLoad();
  }

  Future _preLoad() async{
    codigoDepartamento = widget.initialData?.departamentoCode;
    if(codigoDepartamento == null) return;
    _provinciaController.sink.add(await UbicationAPI.provincias(codigoDepartamento!).then((value) => value.data!));

    codigoProvincia = widget.initialData?.provinciaCode;
    if(codigoProvincia == null) return;
    _distritoController.sink.add(await UbicationAPI.distritos(codigoDepartamento!, codigoProvincia!).then((value) => value.data!));

    codigoDistrito = widget.initialData?.distritoCode;

    widget.controller?.setValue = widget.initialData;

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //? Departamento
        Expanded(
          child: FutureBuilder<List<Map<String, String>>>(
            future: _departamentosList,
            initialData: const [],
            builder: (context, snapshot) {
              return snapshot.data != null && snapshot.data!.isNotEmpty ? _normalDropDown('Departamento', snapshot, (value) async{
                codigoProvincia = null;
                codigoDistrito = null;
                _provinciaController.sink.add(const []);
                _distritoController.sink.add(const []);
    
                codigoDepartamento = value;
                _provinciaController.sink.add(await UbicationAPI.provincias(codigoDepartamento!).then((value) => value.data!));
    
                widget.controller?.setValue = null;
              }, codigoDepartamento) : _defaultDropDown('Departamento');
            }
          ),
        ),
    
        //? Provincia
        Expanded(
          child: StreamBuilder<List<Map<String, String?>>>(
            stream: _provinciaController.stream,
            initialData: const [],
            builder: (context, snapshot) {
              return snapshot.data!.isNotEmpty ? _normalDropDown('Provincia', snapshot, (value) async {
                codigoDistrito = null;
                _distritoController.sink.add(const []);
                
                codigoProvincia = value;
                _distritoController.sink.add(await UbicationAPI.distritos(codigoDepartamento!, codigoProvincia!).then((value) => value.data!));
    
                widget.controller?.setValue = null;
              }, codigoProvincia) : _defaultDropDown('Provincia');
            }
          ),
        ),
    
        //? Distrito
        Expanded(
          child: StreamBuilder<List<Map<String, String?>>>(
            stream: _distritoController.stream,
            initialData: const [],
            builder: (context, snapshot) {
              return snapshot.data!.isNotEmpty ? _normalDropDown('Distrito', snapshot, (value) {
                codigoDistrito = value;
    
                widget.controller?.setValue = NationalUbication([
                  { "departamento": {"codigo": codigoDepartamento!.toString(), "nombre" :null}},
                  { "provincia":    {"codigo": codigoProvincia!.toString(),    "nombre" :null}},
                  { "distrito":     {"codigo": codigoDistrito!.toString(),     "nombre" :null}}
                ]);
              }, codigoDistrito) : _defaultDropDown('Distrito');
            }
          ),
        )
      ]
    );
  }

  @override
  void dispose() {
    _provinciaController.close();
    _distritoController.close();
    super.dispose();
  }

}