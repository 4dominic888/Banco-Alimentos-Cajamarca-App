import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/domain/services/proveedor_service_base.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TypeProveedorField extends StatefulWidget {

  final Key formFieldKey;
  final TypeProveedor? initialValue;
  
  const TypeProveedorField({
    super.key, required this.formFieldKey, this.initialValue
  });


  @override
  State<TypeProveedorField> createState() => _TypeProveedorFieldState();
}

class _TypeProveedorFieldState extends State<TypeProveedorField> {

  final proveedorService = GetIt.I<ProveedorServiceBase>();

  String? _defaultValidator(TypeProveedor? type){
    if(type == null) return 'Campo requerido';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<TypeProveedor>(
      initialValue: widget.initialValue,
      key: widget.formFieldKey,
      builder: (formState) {
        return DropdownSearch<TypeProveedor>(
          asyncItems: (text) async {
            final result = await proveedorService.verTiposDeProveedor(pagina: 1, limite: 8, nombre: text);
            if(!result.success || result.data == null) return [];
            return result.data!.data;                        
          },
          itemAsString: (item) => item.name,
          popupProps: PopupProps.modalBottomSheet(
            showSearchBox: true,
            isFilterOnline: true,
            emptyBuilder: (context, searchEntry) => const Center(child: Text('No encontrado')),
          ),
          selectedItem: widget.initialValue,
          validator: _defaultValidator,
          dropdownDecoratorProps: const DropDownDecoratorProps(
            baseStyle: TextStyle(fontSize: 18, color: Colors.black),
            dropdownSearchDecoration: InputDecoration(
              icon: Icon(Icons.category),
              label: Text('Tipo de proveedor')
            )
          ),
          onChanged: (value) => formState.didChange(value),                      
        );
      },
      validator: _defaultValidator,
    );
  }
}