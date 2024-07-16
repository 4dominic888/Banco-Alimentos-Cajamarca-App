import 'dart:async';
import 'package:bancalcaj_app/modules/control_de_entrada/screens/export_entrada_screen.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/screens/import_entrada_screen.dart';
import 'package:bancalcaj_app/modules/proveedor_module/screens/proveedor_register_screen.dart';
import 'package:bancalcaj_app/modules/proveedor_module/screens/proveedor_view_screen.dart';
import 'package:bancalcaj_app/domain/interfaces/database_interface.dart';
import 'package:bancalcaj_app/data/mongodb/mongodb_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  final dbContext = DatabaseInterface.getInstance(MongoDBMapper());
  await dbContext.init();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp(dbContext: dbContext));
}

class MainApp extends StatelessWidget {
    const MainApp({super.key, required this.dbContext});
    final DatabaseInterface dbContext;

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
          title: "Banco de alimentos app",
          locale: const Locale('es', 'ES'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: const [
            Locale('es', 'ES')
          ],
          home: _RouterScreen(dbContext: dbContext)
        );
    }
}

//? Screen temporal, solo para testeo
class _RouterScreen extends StatelessWidget {
  const _RouterScreen({required this.dbContext});

  final DatabaseInterface dbContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.red, foregroundColor: Colors.white, title: const Text("Exportar entrada")),
        body: Column(children: [
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ImportEntradaScreen(dbContext: dbContext))), child: const Text("Entrada alimentos Import")),
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExportEntradaScreen(dbContext: dbContext))), child: const Text("Entrada alimentos Export")),
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProveedorRegisterScreen(dbContext: dbContext,))), child: const Text('Proveedor register')),
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProveedorViewScreen(dbContext: dbContext,))), child: const Text('Proveedor list'))
        ])
    );
  }
}
