import 'package:flutter/material.dart';

class AutoCompleteField extends StatefulWidget {
  const AutoCompleteField({super.key, required this.recommends, required this.title} );

  final Iterable<String> recommends;
  final String title;

  @override
  State<AutoCompleteField> createState() => AutoCompleteFieldState();
}

class AutoCompleteFieldState extends State<AutoCompleteField> {

  String _text = "";
  String get text => _text;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (field) => Autocomplete<String>(
        optionsBuilder: (textEditingValue) {
            if(textEditingValue.text.isEmpty){
              return const Iterable<String>.empty();
            }
            else{
              return widget.recommends.where((element) => element.toLowerCase().contains(textEditingValue.text.toLowerCase()));
            }
        },
        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) => TextFormField(
          onChanged: (value) {
            setState(() {
              _text = value;
            });
          },
          controller: textEditingController,
          validator: (value) {
            if(value == null || value.trim().isEmpty) return "El campo está vacio";
            return null;
          },
          focusNode: focusNode,
          onEditingComplete: onFieldSubmitted,
          decoration: InputDecoration(
            labelText: widget.title,
          ),
          
        ),
        onSelected: (option) => setState(() {_text = option;})
    ));
  }
}