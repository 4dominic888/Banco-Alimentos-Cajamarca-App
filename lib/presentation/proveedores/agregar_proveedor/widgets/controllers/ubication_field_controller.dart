import 'package:bancalcaj_app/domain/classes/ubication.dart';
import 'package:flutter/material.dart';

class UbicationFieldController extends ChangeNotifier {

  UbicationFieldController([Ubication? ubication]) : _ubication = ubication;

  Ubication? _ubication;

  set setValue(Ubication? value){
    _ubication = value;
    notifyListeners();
  }

  void clear() => _ubication = null;

  Ubication? get ubication => _ubication;

}