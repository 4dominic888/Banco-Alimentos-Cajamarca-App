import 'package:bancalcaj_app/domain/services/employee_service_base.dart';
import 'package:bancalcaj_app/infrastructure/auth_utils.dart';
import 'package:bancalcaj_app/presentation/widgets/loading_process_button.dart';
import 'package:bancalcaj_app/presentation/widgets/notification_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class LoginEmpleadoScreen extends StatefulWidget {
  
  const LoginEmpleadoScreen({super.key});

  @override
  State<LoginEmpleadoScreen> createState() => _LoginEmpleadoScreenState();
}

class _LoginEmpleadoScreenState extends State<LoginEmpleadoScreen> {

  final _formkey = GlobalKey<FormState>();
  final _dniKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();

  final _btnController = RoundedLoadingButtonController();

  final _employeeService = GetIt.I<EmployeeServiceBase>();

  bool _showPassword = false;

  Future<void> onLogin() async {
    if(_formkey.currentState!.validate()){
      final dni = _dniKey.currentState!.value;
      final password = _passwordKey.currentState!.value;

      final result = await _employeeService.login(dni, password);

      if(!result.success){
        NotificationMessage.showErrorNotification(result.message);
        _btnController.error();
        return;
      }

      await GetIt.I<EmployeeGeneralState>().refreshEmployee();

      NotificationMessage.showSuccessNotification('Se ha iniciado sesion como ${GetIt.I<EmployeeGeneralState>().employee.nombre}');
      _btnController.success();
      if(mounted) { Navigator.of(context).pop(); }
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
          title: const Text("Iniciar sesion como empleado"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Focus(
          autofocus: true,
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
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  child: LoadingProcessButton(
                    controller: _btnController,
                    label: const Text('Iniciar sesion', style: TextStyle(color: Colors.white)),
                    color: Colors.red,
                    proccess: onLogin,
                  )
                )

              ],
            ),
          ),
        ),
      )
    );
  }
}