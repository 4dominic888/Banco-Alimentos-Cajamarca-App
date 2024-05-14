import 'dart:async';

import 'package:bancalcaj_app/modules/control_de_entrada/classes/proveedor.dart';
import 'package:bancalcaj_app/shared/repositories/proveedor_repository.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/widgets/auto_completed_field.dart';
import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';
import 'package:flutter/material.dart';

class ProveedorField extends StatefulWidget {
  final DataBaseService dbContext;
  const ProveedorField({super.key, required this.dbContext});

  @override
  State<ProveedorField> createState() => ProveedorFieldState();
}

class ProveedorFieldState extends State<ProveedorField> {

  late final ProveedorRepository proveedorRepo = ProveedorRepository(widget.dbContext);
  final GlobalKey<AutoCompleteFieldState> _keyAutoField = GlobalKey();
  List<Proveedor> _proveedores = [];
  bool _onAvailableConnection = false;

  Future<Iterable<Proveedor>> _getProveedores() async{
    List<Proveedor> list = <Proveedor>[];
    try{
      list = await proveedorRepo.getAll();
      _onAvailableConnection = true;
    }
    on TimeoutException{
      list = [];
      _onAvailableConnection = false;
    }

    _proveedores = list.toList();
    return list;
  }

  Proveedor get proveedor {
    final proveedorName = _keyAutoField.currentState?.text.trim();
    if(_onAvailableConnection){
      return _proveedores.firstWhere((element) => element.nombre.toLowerCase() == proveedorName?.toLowerCase(), orElse: () => Proveedor(id: "0", nombre: proveedorName!));
    }
    return Proveedor(id: "0", nombre: proveedorName!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<Proveedor>>(
          future: _getProveedores(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return AutoCompleteField(
                key: _keyAutoField,
                title: _onAvailableConnection ? "Proveedor" : "Proveedor (sin información)",
                recommends: snapshot.data?.map((e) => e.nombre) ?? [],
                validate: (str) {
                    if(str == null || str.trim().isEmpty) return "El campo está vacio";
                    if(proveedor.id == 0.toString()) return "El proveedor ingresado no existe";
                    return null;
                },
              );
            }
            else{
              return const Column(
                children: [
                  SizedBox(height: 5),
                  SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              );
            }
          }
        );
  }
}