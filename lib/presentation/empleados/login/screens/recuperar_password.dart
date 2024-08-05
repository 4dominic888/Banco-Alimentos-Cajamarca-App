import 'package:bancalcaj_app/domain/services/employee_service_base.dart';
import 'package:bancalcaj_app/presentation/empleados/login/screens/login_empleado_screen.dart';
import 'package:bancalcaj_app/presentation/widgets/dni_form_field.dart';
import 'package:bancalcaj_app/presentation/widgets/loading_process_button.dart';
import 'package:bancalcaj_app/presentation/widgets/notification_message.dart';
import 'package:bancalcaj_app/presentation/widgets/password_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class RecuperarPassword extends StatefulWidget {
  const RecuperarPassword({super.key});

  @override
  State<RecuperarPassword> createState() => _RecuperarPasswordState();
}

class _RecuperarPasswordState extends State<RecuperarPassword> {

  final _employeeService = GetIt.I<EmployeeServiceBase>();

  final _formkey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormFieldState<String>>();
  final _dniKey = GlobalKey<FormFieldState<String>>();
  final _verifyPasswordKey = GlobalKey<FormFieldState<String>>();
  final _btnController = RoundedLoadingButtonController();


  Future<void> _updatePassword() async {
    if(_formkey.currentState!.validate()) {
      final dni = _dniKey.currentState!.value!;
      final password = _passwordKey.currentState!.value!;

      bool? confirm = await showDialog<bool>(context: context, builder: (context) {
        final codeKey = GlobalKey<FormFieldState<String>>();
        bool loading = false;
        return StatefulBuilder(
        builder: (context, alertSetState) => AlertDialog(
          title: const Text('Confirmar cambio de contraseña'),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                const Text('Ingrese el codigo generado por Google Authenticator'),
                TextFormField(
                  key: codeKey,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6)
                  ],
                  decoration: const InputDecoration(
                    label: Text('Codigo'),
                    icon: Icon(Icons.power_input)
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty) return 'Se debe proporcionar el codigo';
                    if(value.length != 6) return 'El codigo es de solo 6 digitos';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                if(loading) const CircularProgressIndicator()
              ],
            ),
          ),
          actions: [
            TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(context).pop(false)),
            TextButton(child: const Text('Aceptar'), onPressed: () async {
              if(codeKey.currentState!.validate()) {
                alertSetState(() => loading = true);
                final result = await _employeeService.recuperarPassword(dni, newPassword: password, code: codeKey.currentState!.value!);
                alertSetState(() => loading = false);

                if(!result.success){
                  NotificationMessage.showErrorNotification(result.message);
                  if(!context.mounted) return;
                  Navigator.of(context).pop(false);
                  return;
                }

                if(!context.mounted) return;
                Navigator.of(context).pop(true);
              }
            })
          ],
        ));
      });

      if(confirm == null || !confirm){
        _btnController.error();
        return;
      }

      NotificationMessage.showSuccessNotification('Se ha cambiado la contrasena satisfactoriamente');
      if(!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginEmpleadoScreen()));
      _btnController.success();
      return;
    }
    _btnController.error();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: const Text("Recuperar contraseña"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: DNIFormField(formKey: _dniKey)
            ),
          
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    child: PasswordFormField(
                      label: 'Nueva contraseña',
                      formKey: _passwordKey,
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
                        if(value == null || value.trim().isEmpty) return 'Este campo no puede estar vacio';
                        value = value.trim();                            
                        if(value != _passwordKey.currentState!.value) return 'las contraseñas no coinciden';
                        return null;
                      },
                    ),
                  ),
                ),
              ]
            ),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: LoadingProcessButton(
                controller: _btnController,
                label: const Text('Actualizar contraseña', style: TextStyle(color: Colors.white)),
                color: Colors.red,
                proccess: _updatePassword,
              )
            ),
          ],
        ),
      ),
    );
  }
}