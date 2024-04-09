import 'package:bancalcaj_app/shared/field_validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecimalField extends StatefulWidget {
  const DecimalField({super.key, required this.label, required this.suffixText, this.emtpyValidate = "empty data\n"});
  final String label;
  final String suffixText;
  final String? emtpyValidate;

  @override
  State<DecimalField> createState() => DecimalFieldState();
}

class DecimalFieldState extends State<DecimalField> implements FieldValidate{

  String _cantidad = "";
  double get cantidad => double.parse(_cantidad);

  @override
  String? get validator{
    if(_cantidad.trim().isEmpty) return "${widget.emtpyValidate}\n";
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
          decoration: InputDecoration(
              labelText: widget.label,
              suffixText: widget.suffixText
          ),
          onChanged: (value) => _cantidad = value,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
            TextInputFormatter.withFunction((oldValue, newValue) {
              final text = newValue.text;
              return text.isEmpty ? newValue :
                  double.tryParse(text) == null ? oldValue : newValue;
            })
          ],
    );
  }
}