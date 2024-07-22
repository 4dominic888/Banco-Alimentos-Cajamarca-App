import 'dart:async';
import 'package:bancalcaj_app/locator.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/ver_entradas/screens/ver_entradas_screen.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/agregar_entrada/screens/agregar_entrada_screen.dart';
import 'package:bancalcaj_app/presentation/proveedores/agregar_proveedor/screens/agregar_proveedor_screen.dart';
import 'package:bancalcaj_app/presentation/proveedores/ver_proveedores/screens/ver_proveedores_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
      return const OverlaySupport.global(
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
      );
  }
}

//? Screen temporal, solo para testeo
class _RouterScreen extends StatelessWidget {
  const _RouterScreen();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.red, foregroundColor: Colors.white, title: const Text("Exportar entrada")),
        body: Column(children: [
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AgregarEntradaScreen())), child: const Text("Entrada alimentos Import")),
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VerEntradasScreen())), child: const Text("Entrada alimentos Export")),
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AgregarProveedorScreen())), child: const Text('Proveedor register')),
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VerProveedoresScreen())), child: const Text('Proveedor list'))
        ])
    );
  }
}
