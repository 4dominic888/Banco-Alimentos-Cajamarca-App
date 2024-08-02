import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DNIFormField extends StatelessWidget {

  final  GlobalKey<FormFieldState<String>> formKey;

  const DNIFormField({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: formKey,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8)
      ],
      decoration: const InputDecoration(
        label: Text('DNI'),
        icon: Icon(Icons.perm_identity)
      ),
      validator: (value) {
        if(value == null || value.isEmpty) return 'Se debe proporcionar el DNI';
        if(value.length != 8) return 'Un DNI debe tener 8 caracteres numericos';
        return null;
      },
    );
  }
}