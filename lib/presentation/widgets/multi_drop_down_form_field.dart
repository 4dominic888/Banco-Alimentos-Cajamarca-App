import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class MultiDropDownFormField<T> extends StatefulWidget {

  final Key formFieldKey;
  final String Function(T value) itemAsString;
  final List<T>? items;
  final List<T>? selectedItems;
  final String label;
  final void Function()? onChanged;
  final Icon? icon;
  final bool Function(T, T)? compareFn;

  const MultiDropDownFormField({super.key,
    required this.formFieldKey,
    required this.itemAsString,
    required this.label,
    this.items,
    this.onChanged,
    this.icon,
    this.compareFn, this.selectedItems
  });

  @override
  State<MultiDropDownFormField<T>> createState() => _MultiDropDownFormFieldState<T>();
}

class _MultiDropDownFormFieldState<T> extends State<MultiDropDownFormField<T>> {
  @override
  Widget build(BuildContext context) {
    return FormField<List<T>>(
      key: widget.formFieldKey,
      builder: (formState) {
        return DropdownSearch<T>.multiSelection(
          selectedItems: widget.selectedItems ?? [],
          items: widget.items ?? [],
          itemAsString: widget.itemAsString,
          popupProps: PopupPropsMultiSelection.bottomSheet(
            showSearchBox: true,
            showSelectedItems: true,
            emptyBuilder: (context, searchEntry) => const Center(child: Text('No encontrado')),
          ),
          compareFn: widget.compareFn,
          validator: (value) {
            if(value == null) return 'Campo requerido';
            return null;
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            baseStyle: const TextStyle(fontSize: 18, color: Colors.black),
            dropdownSearchDecoration: InputDecoration(
              border: InputBorder.none,
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red)
              ),
              errorText: formState.hasError ? formState.errorText ?? '' : null,              
              icon: widget.icon,
              label: Text(widget.label)
            )
          ),
          onChanged: (value) {
            formState.didChange(value);
            widget.onChanged?.call();
          },          
        );
      },

      validator: (value) {
        if(value == null || value.isEmpty) return 'Campo requerido';
        return null;
      },
    );
  }
}