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
class _RouterScreen extends StatelessWidget {
  const _RouterScreen();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.red, foregroundColor: Colors.white, title: const Text("Exportar entrada")),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Entradas de alimentos',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                    ),
                    Expanded(
                      child: Wrap(
                        runSpacing: 15,
                        spacing: 15,
                        runAlignment: WrapAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Card(child: ListTile(
                              title: const Text('Registrar Entradas de alimentos', style: TextStyle(fontSize: 25)),
                              leading: const Icon(Icons.app_registration_rounded),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AgregarEntradaScreen()))
                            ))
                          ),
                          SizedBox(
                            width: 260,
                            child: Card(child: ListTile(
                              title: const Text('Ver Entradas de alimentos', style: TextStyle(fontSize: 25)),
                              leading: const Icon(Icons.list),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VerEntradasScreen()))
                            ))
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                const Spacer(),

                Expanded(
                  child: Column(
                    children: [
                      const Text('Proveedores',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                      ),
                      Wrap(
                        runSpacing: 15,
                        spacing: 15,
                        runAlignment: WrapAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 260,
                            child: Card(child: ListTile(
                              title: const Text('Registrar Proveedores', style: TextStyle(fontSize: 25)),
                              leading: const Icon(Icons.person_add_alt),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AgregarProveedorScreen()))
                            ))
                          ),
                          SizedBox(
                            width: 260,
                            child: Card(child: ListTile(
                              title: const Text('Ver proveedores', style: TextStyle(fontSize: 25)),
                              leading: const Icon(Icons.group),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VerProveedoresScreen()))
                            ))
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}
