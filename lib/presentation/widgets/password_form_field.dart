import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {

  final String label;
  final GlobalKey<FormFieldState<String>> formKey;
  final String? Function(String? value)? validator;

  const PasswordFormField({super.key, required this.label, required this.formKey, this.validator});

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.formKey,
      obscureText: !_showPassword,
      decoration: InputDecoration(
        suffix: IconButton(
          icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: (){
            setState(() => _showPassword = !_showPassword);
          },
        ),
        label: Text(widget.label),
        icon: const Icon(Icons.password)
      ),
      validator: (value) {
        if(value == null || value.trim().isEmpty) return 'Se debe proporcionar una contraseña';
        value = value.trim();
        if(value.length < 6) return 'Contraseña muy corta';
        return null;
      },
    );
  }
}




class VerifyPasswordFormField extends StatefulWidget {

  final String? Function(String? value)? validator;
  final GlobalKey<FormFieldState<String>> formKey;

  const VerifyPasswordFormField({super.key, required this.formKey, this.validator});

  @override
  State<VerifyPasswordFormField> createState() => _VerifyPasswordFormFieldState();
}

class _VerifyPasswordFormFieldState extends State<VerifyPasswordFormField> {

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.formKey,
      obscureText: !_showPassword,
      decoration: InputDecoration(
        suffix: IconButton(
          icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: (){
            setState(() => _showPassword = !_showPassword);
          },
        ),
        label: const Text('Confirmar Contraseña'),
        icon: const Icon(Icons.password)
      ),
      validator: widget.validator
    );
  }
}