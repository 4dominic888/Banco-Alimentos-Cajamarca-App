import 'package:bancalcaj_app/shared/field_validate.dart';
import 'package:flutter/material.dart';

class ValidateTextField extends StatefulWidget {
  const ValidateTextField({super.key, required this.title, this.emtpyValidate = "Empty data\n"});

  final String title;
  final String? emtpyValidate;

  @override
  State<ValidateTextField> createState() => ValidateTextFieldState();
}

class ValidateTextFieldState extends State<ValidateTextField> implements FieldValidate {
  
  String? get validator {
    if(_value.trim().isEmpty) return "${widget.emtpyValidate}\n";
    return "";
  }
  
  String _value = "";
  String get value => _value;
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) => _value = value,
      decoration: InputDecoration(
        label: Text(widget.title)
      ),
    );
  }

}