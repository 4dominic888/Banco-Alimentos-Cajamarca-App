import 'dart:convert';

import 'package:bancalcaj_app/domain/models/employee.dart';
import 'package:bancalcaj_app/domain/services/employee_service_base.dart';
import 'package:bancalcaj_app/presentation/widgets/loading_process_button.dart';
import 'package:bancalcaj_app/presentation/widgets/multi_drop_down_form_field.dart';
import 'package:bancalcaj_app/presentation/widgets/notification_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class RegisterEmpleadoScreen extends StatefulWidget {
  const RegisterEmpleadoScreen({super.key});

  @override
  State<RegisterEmpleadoScreen> createState() => _RegisterEmpleadoScreenState();
}

class _RegisterEmpleadoScreenState extends State<RegisterEmpleadoScreen> {


  final _formkey = GlobalKey<FormState>();
  final _dniKey = GlobalKey<FormFieldState<String>>();
  final _nombreKey = GlobalKey<FormFieldState<String>>();
  final _passwordKey = GlobalKey<FormFieldState<String>>();
  final _rolesKey = GlobalKey<FormFieldState<List<EmployeeType>>>();

  final _btnController = RoundedLoadingButtonController();
  final _employeeService = GetIt.I<EmployeeServiceBase>();

  String? qrCode;
  bool _showPassword = false;

  Future<void> onRegister() async {
    if(_formkey.currentState!.validate()){

      final String password = _passwordKey.currentState!.value!;

      final employee = Employee(
        dni: _dniKey.currentState!.value!,
        nombre: _nombreKey.currentState!.value!,
        types: _rolesKey.currentState!.value!
      );

      final result = await _employeeService.register(employee, password);
      if(!result.success){
        NotificationMessage.showErrorNotification(result.message);
        _btnController.error();
        return;
      }

      NotificationMessage.showSuccessNotification('Usuario ${employee.nombre} creado con exito');
      setState(() {
        qrCode = result.data;
      });

      _btnController.success();
      return;
    }
    _btnController.error();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: { const SingleActivator(LogicalKeyboardKey.escape) : Navigator.of(context).pop },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          title: const Text("Registrar empleados"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Focus(
          autofocus: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //* DNI Field
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      key: _dniKey,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8)
                      ],
                      decoration: const InputDecoration(
                        label: Text('DNI'),
                        icon: Icon(Icons.perm_identity)
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty) return 'Se debe proporcionar el DNI';
                        if(value.length != 8) return 'Un DNI debe tener 8 caracteres numericos';
                        return null;
                      },
                    ),
                  ),

                  //* Nombre field
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    child: TextFormField(
                      key: _nombreKey,
                      decoration: const InputDecoration(icon: Icon(Icons.text_fields), label: Text('Nombre y Apellidos completos del empleado')),
                      validator: (value) {
                        if(value == null || value.trim().isEmpty) return 'Se debe proporcionar una nombre';
                        value = value.trim();
                        if(value.length <= 3) return 'El nombre es muy corto';
                        return null;
                      },
                    ),
                  ),

                  //* Roles field
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    child: MultiDropDownFormField<EmployeeType>(
                      formFieldKey: _rolesKey,
                      items: EmployeeType.values,
                      itemAsString: (value) => Employee.employeeTypeMap[value]!,
                      label: 'Roles del usuario',
                      compareFn: (v1, v2) => v1.index == v2.index,
                      icon: const Icon(Icons.type_specimen),
                    ),
                  ),

                  //* Password field
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    child: TextFormField(
                      key: _passwordKey,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        suffix: IconButton(
                          icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: (){
                            setState(() => _showPassword = !_showPassword);
                          },
                        ),
                        label: const Text('Contraseña'),
                        icon: const Icon(Icons.password)
                      ),
                      validator: (value) {
                        if(value == null || value.trim().isEmpty) return 'Se debe proporcionar una contraseña';
                        value = value.trim();
                        if(value.length < 6) return 'Contraseña muy corta';
                        return null;
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    child: LoadingProcessButton(
                      controller: _btnController,
                      label: const Text('Registrar empleado', style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                      proccess: onRegister,
                    )
                  ),

                  if(qrCode != null) Center(
                    child: Column(
                      children: [
                        const Text('Guarda este codigo QR para que el usuario de esta cuenta pueda recuperar su contraseña\nSe debe escanear en la aplicacion de Google Authenticator\n', style: TextStyle(fontSize: 26)),
                        const Text('No habra otra manera de recuperar la contraseña del usuario', style: TextStyle(fontSize: 26)),
                        Image.memory(
                          base64Decode(qrCode!.split(',').last),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width / 4.5,
                        )
                        // QrImageView(
                        //   data: qrCode!,
                        //   padding: const EdgeInsets.all(20.0),
                        //   size: MediaQuery.of(context).size.width / 4.5,
                        // ),
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}