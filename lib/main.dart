import 'package:bancalcaj_app/modules/control_de_entrada/screens/home.dart';
import 'package:bancalcaj_app/services/dbservices/data_base_service.dart';
import 'package:bancalcaj_app/services/dbservices/mongodb_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future main() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dbContext = DataBaseService.getInstance(MongoDBService());
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
          home: ControlEntradaScreen(dbContext: dbContext)
        );
    }
}
