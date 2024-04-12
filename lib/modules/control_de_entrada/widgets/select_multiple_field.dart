import 'package:flutter/material.dart';

class _Pair {
  int index;
  String? value;
  _Pair(this.index, this.value);
}

//! Widget en deshuso, arreglar luego
@deprecated
class SelectMultipleField extends StatefulWidget {
  const SelectMultipleField({super.key, required this.label, required this.titleModalCustom, required this.hintModalCustom, required this.hintSelectElements, required this.list});

  final String label;
  final String titleModalCustom;
  final String hintModalCustom;
  final String hintSelectElements;
  final List<String> list;

  @override
  State<SelectMultipleField> createState() => SelectMultipleFieldState();
}

class SelectMultipleFieldState extends State<SelectMultipleField> {

  List<String> get products  => _listWrap.map((e) => e.value!).toList();

  final _textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<_Pair> _listWrap = [];
  final List<_Pair> _listSelect = []; // or list of dropdownbutton
  final String _other = "Otros";

  //? Sirve a modo de validador del texto del customOption
  String? get _errorTextCustomOption {
      final text = _textFieldController.value.text;

      if(text.trim().isEmpty){
        return 'El campo no debe estar vacío';
      }
      if(_listWrap.any((element) => text.toLowerCase().trim() == element.value?.toLowerCase().trim())){
        return 'El campo ya ha sido ingresado';
      }
      if(_listSelect.any((element) => text.toLowerCase().trim() == element.value?.toLowerCase().trim())){
        return 'El campo ya existe en la lista desplegable';
      }
      return null;
    }

  //? Ventana emergente para el customOption
  Future<String?> _showAddOptionDialog(BuildContext context) async{
    String? customOption = '';
    return showDialog<String>(
      context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.titleModalCustom),
          content: Form(
            key: _formKey,
            child: TextFormField(
                onChanged: (value){
                  customOption = value;
                },
                textInputAction: TextInputAction.go,
                controller: _textFieldController,
                decoration: InputDecoration(
                  hintText: widget.hintModalCustom, 
                ),
                validator: (value) => _errorTextCustomOption,
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(null);
              }
            ),
            TextButton(
              child: const Text("Aceptar"),
              onPressed: () {
                if(_formKey.currentState!.validate()) Navigator.of(context).pop(customOption?.trim().replaceAll(RegExp(r'\s+'), ' '));
              }
            ),
          ],

        );
      },
    );
  }

  //? Contenedor de los productos
  Widget _warpElements(){
    return Wrap(
      runSpacing: 10,
      spacing: 13,
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      children: _listWrap.map(
        (_Pair e) => InputChip(

          labelPadding: const EdgeInsets.all(2),
          label: Text(e.value!),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          onDeleted: (){
            setState(() {
              if(e.index != -1) _listSelect.insert(e.index, e);
              _listWrap.remove(e);
            });
          },

      )).toList(),
    );
  }

  //? Vista de lista desplegable
  Widget _dropDownList(){
    return DropdownButton(
      hint: Text(widget.hintSelectElements),
      items: _listSelect.map<DropdownMenuItem<_Pair>>((e) => 
        DropdownMenuItem(
          value: e,
          child: Text(e.value!)
        )
      ).toList(),
      onChanged: (_Pair? selectedItem) async {
          if(selectedItem?.value == _other) { //* Si se selecciona otros como opcion
            _Pair customOption = _Pair(-1, await _showAddOptionDialog(context));
            _textFieldController.clear();
            if(customOption.value != null) { //* En caso se de la opción de cancelar o suceda algun error, no se registra
              setState(() {
                _listWrap.add(customOption);
              });
            }
          }
          else{
            setState(() {
              _listWrap.add(selectedItem!);
              _listSelect.remove(selectedItem);
            });
          }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    int length = widget.list.length;
    for (int i = 0; i < length; i++) {
      _listSelect.add(_Pair(i, widget.list[i]));
    }
    _listSelect.add(_Pair(length+1, _other));
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(fontSize: 22),
        border: InputBorder.none
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            _listWrap.isEmpty ? Container() : _warpElements(),
            
            const SizedBox(height: 10),

            _dropDownList(),
            
          ],
        ),
    );
  }
}