import 'package:flutter/material.dart';

class RadioButtonListController extends ChangeNotifier {
  int _selectedIndex = 0;

  set setValue(int i){
    _selectedIndex = i;
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;
}