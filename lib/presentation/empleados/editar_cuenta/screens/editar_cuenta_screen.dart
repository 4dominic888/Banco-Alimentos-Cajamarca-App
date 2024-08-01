import 'package:bancalcaj_app/domain/models/employee.dart';
import 'package:bancalcaj_app/domain/services/employee_service_base.dart';
import 'package:bancalcaj_app/presentation/widgets/loading_process_button.dart';
import 'package:bancalcaj_app/presentation/widgets/notification_message.dart';
import 'package:bancalcaj_app/presentation/widgets/password_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class EditarCuentaScreen extends StatefulWidget {

  final Employee employee;

  const EditarCuentaScreen({super.key, required this.employee});

  @override
  State<EditarCuentaScreen> createState() => _EditarCuentaScreenState();
}

class _EditarCuentaScreenState extends State<EditarCuentaScreen> {

  final _employeeService = GetIt.I<EmployeeServiceBase>();

  final _nameKey = GlobalKey<FormFieldState<String>>();
  final _btnNameController = RoundedLoadingButtonController();

  final _passwordKey = GlobalKey<FormFieldState<String>>();
  final _verifyPasswordKey = GlobalKey<FormFieldState<String>>();
  final _btnPasswordController = RoundedLoadingButtonController();

  Future<void> _updateName() async {
    if(_nameKey.currentState!.validate()) {

      final result = await _employeeService.actualizarNombre(widget.employee.dni, _nameKey.currentState!.value!);
      if(!result.success){
        _btnNameController.error();
        NotificationMessage.showErrorNotification(result.message);
        return;
      }

      _btnNameController.success();
      NotificationMessage.showSuccessNotification('Actualizacion del nombre exitoso');
      return;
    }
    _btnNameController.error();
  }

  Future<void> _updatePassword() async {
    if(_passwordKey.currentState!.validate() && _verifyPasswordKey.currentState!.validate()) {

      final password = _passwordKey.currentState!.value!;

      final result = await _employeeService.actualizarPassword(widget.employee.dni, password);
      if(!result.success){
        _btnPasswordController.error();
        NotificationMessage.showErrorNotification(result.message);
        return;
      }

      _btnPasswordController.success();
      NotificationMessage.showSuccessNotification('Actualizacion del contraseña exitoso');
      return;
    }
    _btnPasswordController.error();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: { const SingleActivator(LogicalKeyboardKey.escape) : Navigator.of(context).pop },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          title: const Text("Editar cuenta"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Focus(
          autofocus: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Update Name
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        key: _nameKey,
                        decoration: const InputDecoration(
                          label: Text('Nuevo Nombre'),
                          icon: Icon(Icons.person)
                        ),
                        validator: (value) {
                          if(value == null || value.trim().isEmpty) return 'Se debe proporcionar una nombre';
                          value = value.trim();
                          if(value.length <= 3) return 'El nombre es muy corto';
                          return null;
                        },                        
                        initialValue: widget.employee.nombre,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      child: LoadingProcessButton(
                        controller: _btnNameController,
                        label: const Text('Actualizar nombre', style: TextStyle(color: Colors.white)),
                        color: Colors.red,
                        proccess: _updateName,
                      )
                    ),
                  )
                ],
              ),

              //* Change password field
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                      child: PasswordFormField(
                        formKey: _passwordKey,
                        label: 'Nueva Contraseña',
                        validator: (value) {
                          if(value == null || value.trim().isEmpty) return 'Se debe proporcionar una contraseña';
                          value = value.trim();
                          if(value.length < 6) return 'Contraseña muy corta';
                          return null;
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                      child: VerifyPasswordFormField(
                        formKey: _verifyPasswordKey,
                        validator: (value) {
                          if(value == null || value.trim().isEmpty) return 'Se debe proporcionar una contraseña';
                          value = value.trim();
                          if(value != _passwordKey.currentState!.value!) return 'las contraseñas no coinciden';
                          return null;                          
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      child: LoadingProcessButton(
                        controller: _btnPasswordController,
                        label: const Text('Actualizar contraseña', style: TextStyle(color: Colors.white)),
                        color: Colors.red,
                        proccess: _updatePassword,
                      )
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}