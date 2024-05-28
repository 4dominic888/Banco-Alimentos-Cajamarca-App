import 'package:bancalcaj_app/modules/proveedor_module/classes/ubication.dart';
import 'package:flutter/material.dart';

class UbicationFieldController extends ChangeNotifier {
  Ubication? _ubication;

  set setValue(Ubication? value){
    _ubication = value;
    notifyListeners();
  }

  void clear() => _ubication = null;

  Ubication? get ubication => _ubication;

}