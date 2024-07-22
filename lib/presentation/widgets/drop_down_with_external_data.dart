import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropDownWithExternalData<T> extends StatefulWidget {

  final Key formFieldKey;
  final T? initialValue;
  final Future<List<T>> Function(String text) asyncItems;
  final String Function(T value) itemAsString;
  final String label;

  const DropDownWithExternalData({
    super.key,
    required this.formFieldKey,
    required this.asyncItems,
    required this.itemAsString,
    required this.label,
    this.initialValue,
  });

  @override
  State<DropDownWithExternalData<T>> createState() => _TypeDropDownWithExternalDataState<T>();
}

class _TypeDropDownWithExternalDataState<T> extends State<DropDownWithExternalData<T>> {

  String? _defaultValidator(T? type){
    if(type == null) return 'Campo requerido';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: widget.initialValue,
      key: widget.formFieldKey,
      builder: (formState) {
        return DropdownSearch<T>(
          asyncItems: widget.asyncItems,
          itemAsString: widget.itemAsString,
          popupProps: PopupProps.modalBottomSheet(
            showSearchBox: true,
            isFilterOnline: true,
            emptyBuilder: (context, searchEntry) => const Center(child: Text('No encontrado')),
          ),
          selectedItem: widget.initialValue,
          validator: _defaultValidator,
          dropdownDecoratorProps: DropDownDecoratorProps(
            baseStyle: const TextStyle(fontSize: 18, color: Colors.black),
            dropdownSearchDecoration: InputDecoration(
              icon: const Icon(Icons.category),
              label: Text(widget.label)
            )
          ),
          onChanged: (value) => formState.didChange(value),                      
        );
      },
      validator: _defaultValidator,
    );
  }
}