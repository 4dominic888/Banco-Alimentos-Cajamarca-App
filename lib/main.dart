import 'package:bancalcaj_app/modules/control_de_entrada/screens/export_entrada.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/screens/import_entrada.dart';
import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';
import 'package:bancalcaj_app/services/dbservices/json_server_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future main() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dbContext = DataBaseService.getInstance(JsonServerService());
    await dbContext.init();

    runApp(MainApp(dbContext: dbContext));
}

class MainApp extends StatelessWidget {
    const MainApp({super.key, required this.dbContext});
    final DataBaseService dbContext;

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
  const _RouterScreen({super.key, required this.dbContext});

  final DataBaseService dbContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.red, foregroundColor: Colors.white, title: const Text("Exportar entrada")),
        body: Column(children: [
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ImportEntradaScreen(dbContext: dbContext))), child: const Text("Entrada alimentos Import")),
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExportEntradaScreen(dbContext: dbContext))), child: const Text("Entrada alimentos Export"))
        ],),
    );
  }
}
