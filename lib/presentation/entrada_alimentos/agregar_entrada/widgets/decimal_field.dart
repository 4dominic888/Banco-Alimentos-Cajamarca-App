import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecimalField extends StatefulWidget {
  const DecimalField({super.key, required this.label, required this.suffixText, this.isLocked = false, this.controller});
  final String label;
  final String suffixText;
  final bool? isLocked;
  final TextEditingController? controller;

  @override
  State<DecimalField> createState() => DecimalFieldState();
}

class DecimalFieldState extends State<DecimalField>{

  String _cantidad = "0";
  double get cantidad => double.parse(_cantidad);

  @override
  void dispose() {
    super.dispose();
    widget.controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
              labelText: widget.label,
              suffixText: widget.suffixText
          ),
          //enabled: !widget.isLocked!
          onChanged: (value) => _cantidad = value,
          readOnly: widget.isLocked!,
          keyboardType: TextInputType.number,
          validator: (value) {
            if(value!.trim().isEmpty) return "El número esta vacío";
            if(cantidad == 0) return "El número no debe ser 0";
            return null;
          },
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