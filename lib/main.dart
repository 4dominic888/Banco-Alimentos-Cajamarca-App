import 'dart:async';
import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:bancalcaj_app/domain/models/employee.dart';
import 'package:bancalcaj_app/domain/services/employee_service_base.dart';
import 'package:bancalcaj_app/infrastructure/auth_utils.dart';
import 'package:bancalcaj_app/locator.dart';
import 'package:bancalcaj_app/presentation/empleados/editar_cuenta/screens/editar_cuenta_screen.dart';
import 'package:bancalcaj_app/presentation/empleados/login/screens/login_empleado_screen.dart';
import 'package:bancalcaj_app/presentation/empleados/register/screens/register_empleado_screen.dart';
import 'package:bancalcaj_app/presentation/empleados/ver_empleados/screens/ver_empleados_screen.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/ver_entradas/screens/ver_entradas_screen.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/agregar_entrada/screens/agregar_entrada_screen.dart';
import 'package:bancalcaj_app/presentation/proveedores/agregar_proveedor/screens/agregar_proveedor_screen.dart';
import 'package:bancalcaj_app/presentation/proveedores/ver_proveedores/screens/ver_proveedores_screen.dart';
import 'package:bancalcaj_app/presentation/widgets/notification_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  
  //* Get the instance of employee
  await GetIt.I<EmployeeGeneralState>().refreshEmployee();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
      return InteractiveViewer(
        constrained: true,
        child: const OverlaySupport.global(
          child: MaterialApp(
            title: "Banco de alimentos app",
            locale: Locale('es', 'ES'),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: [ Locale('es', 'ES') ],
            home: _RouterScreen()
          ),
        ),
      );
  }
}

//? Screen temporal, solo para testeo
class _RouterScreen extends StatefulWidget {
  const _RouterScreen();

  @override
  State<_RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<_RouterScreen> {

  final _fabKey =GlobalKey<AnimatedFloatingActionButtonState>();
  bool _isLoading = false;

  final _employeeGeneralState = GetIt.I<EmployeeGeneralState>();

  List<Widget> unregisteredOptions() => [
    FloatingActionButton(
      heroTag: 'login',
      tooltip: 'Iniciar sesion',
      child: const Icon(Icons.login_sharp),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginEmpleadoScreen())).then((value) => setState(() {})),
    ),
    
    const SizedBox.shrink()  
  ];

  List<Widget> employeeOptions() => [
    FloatingActionButton(
      heroTag: 'logout',
      tooltip: 'Salir de la sesion',
      child: const Icon(Icons.exit_to_app),
      onPressed: () async {
        setState(() => _isLoading = true);
        final result = await GetIt.I<EmployeeServiceBase>().logout();
        setState(() {
          if(!result.success){
            NotificationMessage.showErrorNotification(result.message);
            _isLoading = false;
            _fabKey.currentState?.closeFABs();
            return;
          }
          NotificationMessage.showSuccessNotification('Se ha cerrado sesion correctamente');
          _isLoading = false;
          _fabKey.currentState?.closeFABs();
        });
      },
    ),

    FloatingActionButton(
      heroTag: 'editAccout',
      tooltip: 'Edita tu cuenta',
      child: const Icon(Icons.edit),
      onPressed: (){
        if(AuthUtils.isNotEmployeeAuthenticate || _employeeGeneralState.employee.dni.isEmpty) {NotificationMessage.showErrorNotification('Empleado no autenticado'); return;}
        Navigator.push(context, MaterialPageRoute(builder: (_) => EditarCuentaScreen(employee: _employeeGeneralState.employee)));
      },
    ),

    FloatingActionButton(
      heroTag: 'refreshAccount',
      tooltip: 'Actualiza tus datos de usuario',
      child: const Icon(Icons.refresh),
      onPressed: () async{
        setState(() => _isLoading = true);
        await GetIt.I<EmployeeGeneralState>().refreshEmployee();
        setState(() {
          _fabKey.currentState?.closeFABs();
          _isLoading = false;
        });
      },
    )
  ];

  List<Widget> administratorOptions() => [
    FloatingActionButton(
      heroTag: 'monitorate',
      tooltip: 'Monitorea a los empleados',
      child: const Icon(Icons.app_registration_rounded),
      onPressed: () async {
        if(AuthUtils.isNotEmployeeAuthenticate || _employeeGeneralState.employee.dni.isEmpty) {NotificationMessage.showErrorNotification('Empleado no autenticado'); return;}
        Navigator.push(context, MaterialPageRoute(builder: (_) => const VerEmpleadosScreen()));
      },
    ),

    FloatingActionButton(
      heroTag: 'register',
      tooltip: 'Registra nuevos usuarios',
      child: const Icon(Icons.person_add),
      onPressed: () async {
        if(AuthUtils.isNotEmployeeAuthenticate) {NotificationMessage.showErrorNotification('Empleado no autenticado'); return;}
        Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterEmpleadoScreen()));
      },
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.red, foregroundColor: Colors.white, title: const Text("Exportar entrada")),
        persistentFooterButtons: [
          if(_isLoading) const CircularProgressIndicator(),
          Text(_employeeGeneralState.employee.dni),
          Text(_employeeGeneralState.employee.nombre),
          Text('[${_employeeGeneralState.employee.typesStr}]'),
          // Text(AuthUtils.refreshToken ?? 'no token')
        ],
        floatingActionButton: AnimatedFloatingActionButton(
          key: _fabKey,
          fabButtons: AuthUtils.refreshToken == null ? 
            unregisteredOptions() : [...employeeOptions(), if(GetIt.I<EmployeeGeneralState>().employee.types.contains(EmployeeType.administrador)) ...administratorOptions() ],
          colorStartAnimation: Colors.red.shade300,
          colorEndAnimation: Colors.red.shade200,
          animatedIconData: AnimatedIcons.home_menu,
        ),
        body: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicWidth(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Entradas de alimentos',
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Card(child: ListTile(
                                    title: const Text('Registrar Entradas de alimentos', style: TextStyle(fontSize: 16)),
                                    leading: const Icon(Icons.app_registration_rounded),
                                    onTap: () {
                                      if(AuthUtils.isNotEmployeeAuthenticate) {NotificationMessage.showErrorNotification('Empleado no autenticado'); return;}
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AgregarEntradaScreen()));
                                    }
                                  ))
                                ),
                                SizedBox(
                                  width: 260,
                                  child: Card(child: ListTile(
                                    title: const Text('Ver Entradas de alimentos', style: TextStyle(fontSize: 16)),
                                    leading: const Icon(Icons.list),
                                    onTap: () {
                                      if(AuthUtils.isNotEmployeeAuthenticate) {NotificationMessage.showErrorNotification('Empleado no autenticado'); return;}
                                      if(AuthUtils.isNotEmployeeAsAdmin!) {NotificationMessage.showErrorNotification('Acceso denegado'); return;}
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => const VerEntradasScreen()));
                                    }
                                  ))
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                                
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Proveedores',
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 280,
                                  child: Card(child: ListTile(
                                    title: const Text('Registrar Proveedores', style: TextStyle(fontSize: 16)),
                                    leading: const Icon(Icons.person_add_alt),
                                    onTap: () {
                                      if(AuthUtils.isNotEmployeeAuthenticate) {NotificationMessage.showErrorNotification('Empleado no autenticado'); return;}
                                      if(AuthUtils.isNotEmployeeAsAdmin!) {NotificationMessage.showErrorNotification('Acceso denegado'); return;}
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AgregarProveedorScreen()));
                                    }
                                  ))
                                ),
                                SizedBox(
                                  width: 260,
                                  child: Card(child: ListTile(
                                    title: const Text('Ver proveedores', style: TextStyle(fontSize: 16)),
                                    leading: const Icon(Icons.group),
                                    onTap: () {
                                      if(AuthUtils.isNotEmployeeAuthenticate) {NotificationMessage.showErrorNotification('Empleado no autenticado'); return;}
                                      if(AuthUtils.isNotEmployeeAsAdmin!) {NotificationMessage.showErrorNotification('Acceso denegado'); return;}
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => const VerProveedoresScreen()));
                                    }
                                  ))
                                ),
                              ],
                            ),
                          )
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
