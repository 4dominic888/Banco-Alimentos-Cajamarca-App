import 'package:flutter/material.dart';

class AutoCompleteField extends StatefulWidget {
  const AutoCompleteField({super.key, required this.recommends, required this.title, this.validate} );

  final Iterable<String> recommends;
  final String title;
  final String? Function(String?)? validate;

  @override
  State<AutoCompleteField> createState() => AutoCompleteFieldState();
}

class AutoCompleteFieldState extends State<AutoCompleteField> {

  String _text = "";
  String get text => _text;
  Iterable<String> list = [];

  @override
  void initState() {
    list = widget.recommends;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (field) => Autocomplete<String>(
        optionsBuilder: (textEditingValue) {
          return list.where((element) => element.toLowerCase().contains(textEditingValue.text.toLowerCase())).take(6);
        },
        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) => TextFormField(
          onChanged: (value) {
            setState(() {
              _text = value;
            });
          },
          controller: textEditingController,
          validator: widget.validate,
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