import 'package:bancalcaj_app/modules/control_de_entrada/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
    runApp(const MainApp());
}

class MainApp extends StatelessWidget {
    const MainApp({super.key});

    @override
    Widget build(BuildContext context) {
        return const MaterialApp(
          title: "Banco de alimentos app",
          locale: Locale('es', 'ES'),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: [
            Locale('es', 'ES')
          ],
          home: ControlEntradaScreen()
        );
    }
}
