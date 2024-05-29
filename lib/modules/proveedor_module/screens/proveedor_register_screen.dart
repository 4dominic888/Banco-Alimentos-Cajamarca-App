import 'package:bancalcaj_app/modules/control_de_entrada/classes/proveedor.dart';
import 'package:bancalcaj_app/modules/proveedor_module/classes/ubication.dart';
import 'package:bancalcaj_app/modules/proveedor_module/widgets/ubication_form_field.dart';
import 'package:flutter/material.dart';

class ProveedorRegisterScreen extends StatefulWidget {
  const ProveedorRegisterScreen({super.key});

  static List<String> tipoProveedorSelects = [
    'Supermercado',
    'Comida Rápida',
    'Consecionario Comedores Mineros',
    'Centro de Abastos',
    'Persona Natural',
    'Medio de Comunicación',
    'Proyecto Parroquial',
    'Centro de Catequesis',
    'Cooperativa de Ahorro y Crédito',
    'Asociación Sin fines de Lucro',
    'Diócesis',
    'Programa',
    'Mayorista',
    'Agroexportadora',
    'Servicios agrícolas',
    'Asociación',
    'Colecta',
    'Institución Pública',
    'Institución Educativa',
    'Consorcio',
    'Agroindustria',
    'Minería',
    'Colecta Navideña',
    'Distribuidor Logístico',
    'Programa del BACAJ',
    'Actividad/Oficina Municipal',
    'Comerciante Cárnico',
    'ONG',
    'Derrama Magisterial',
    'I.E.P.',
    'Organismo Público'
  ];

  @override
  State<ProveedorRegisterScreen> createState() => _ProveedorRegisterScreenState();
}

class _ProveedorRegisterScreenState extends State<ProveedorRegisterScreen> {


  final _formkey = GlobalKey<FormState>();
  static final _proveedorNameKey = GlobalKey<FormFieldState>();
  static final _proveedorTypeKey = GlobalKey<FormFieldState>();
  static final _proveedorUbicationKey = GlobalKey<FormFieldState<Ubication>>();

  void onSubmit() {
    if (_formkey.currentState!.validate()) {

      final Proveedor proveedor = Proveedor.toSend(
        nombre: _proveedorNameKey.currentState?.value,
        typeProveedor: _proveedorTypeKey.currentState?.value,
        ubication: _proveedorUbicationKey.currentState!.value!
      );

      print(proveedor.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: const Text("Registro de proveedores"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              //* Nombre del proveedor
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  key: _proveedorNameKey,
                  decoration: const InputDecoration(
                    label: Text("Nombre del proveedor"),
                    icon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if(value != null && value.trim().isNotEmpty){
                      return null;
                    }
                    return 'No se ha proporcionado un nombre';
                  },
                ),
              ),
          
              //* Tipo de proveedor
              Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                child: DropdownButtonFormField<String>(
                  key: _proveedorTypeKey,
                  onChanged: (_) {},
                  menuMaxHeight: 280,
                  items: ProveedorRegisterScreen.tipoProveedorSelects.map<DropdownMenuItem<String>>((String value) =>
                    DropdownMenuItem<String>(
                      value: ProveedorRegisterScreen.tipoProveedorSelects.indexOf(value).toString(),
                      child: Text(value),
                    )
                  ).toList(),
                  decoration: const InputDecoration(
                    label: Text("Tipo de proveedor"),
                    icon: Icon(Icons.category)
                  ),
                  validator: (value) {
                    if (value != null) {
                      return null;
                    }
                    return 'No se ha seleccionado una opcion';
                  },
                )
              ),
        
              //* Ubicacion
              Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                child: UbicationFormField(
                  formFieldKey: _proveedorUbicationKey,
                  validator: (value) {
                    if (value == null) {
                      return 'No se ha proporcionado una ubicacion completa';
                    }
                    return null;
                  },
                )
              ),
          
              //* Button
              Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white
                  ),  
                  child: const Text("Registrar")
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}