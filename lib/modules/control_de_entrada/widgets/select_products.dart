import 'dart:collection';

import 'package:bancalcaj_app/domain/classes/producto.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/screens/add_product_dialog.dart';
import 'package:flutter/material.dart';

class SelectProductsField extends StatefulWidget {
  const SelectProductsField({super.key, required this.defaultCommonProducts});
  final List<String> defaultCommonProducts;

  @override
  State<SelectProductsField> createState() => SelectProductsFieldState();
}

class SelectProductsFieldState extends State<SelectProductsField> {

  final List<String> _listSelect = [];
  final Map<String, List<Producto>> _listProducts = {};
  final HashSet<String> _listTypeProducts = HashSet();
  double _cantidadTotal = 0.00;

  Map<String, List<Producto>> get listProducts => _listProducts;
  double get cantidadTotal => _cantidadTotal;

  @override
  void initState() {
    super.initState();
    _listSelect.addAll(widget.defaultCommonProducts);
    _listSelect.add("Otros");
  }

  Future<void> _showProductsAddedDialog(BuildContext context, String optionSelected) async{

    final List<Producto> lista = _listProducts[optionSelected]!;

    return showDialog(context: context, builder: (context) => AlertDialog(
      scrollable: true,
      title: Text("Productos agregados de tipo: $optionSelected"),
      content: StatefulBuilder(
        builder: (context, setState) => SizedBox(
          height: 300,
          width: 300,
          child: lista.isNotEmpty ? ListView.builder(
            shrinkWrap: true,
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final element = lista[index];
              return ListTile(
                title: Text(element.nombre),
                subtitle: Text("${element.peso.toString()} kg"),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    //* to close
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Producto eliminado"),
                          backgroundColor: Colors.red, duration:
                          Duration(seconds: 2)
                        )
                      );
                      _cantidadTotal -= element.peso;
                      lista.removeAt(index);
                    });
                  },
                ),
              );
            }, 
          ) : const Center(child: Text("No hay productos")),
        ),
      ),
    ));
  }

  Future<bool?> _deleteGroupTypeProductsDialog(BuildContext context, String optionSelected) async{
    return showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: Text("¿Borrar $optionSelected?"),
      content: const Text("¿Estás seguro de que quieres borrar este grupo de alimentos?"),
      actions: [
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text("Aceptar"),
          onPressed: () => Navigator.of(context).pop(true),
        )
      ],
    ));
  }

  Widget _dropDownProducts(){
    return DropdownButtonFormField(
      hint: const Text("Selecciona el tipo de producto"),
      items: _listSelect.map<DropdownMenuItem<String>>((e) => DropdownMenuItem(value: e, child: Text("Agregar $e"))).toList(),
      validator: (value) {
        if(_listProducts.isEmpty) return "No se ha seleccionado productos";
        return null;
      },
      decoration: const InputDecoration(
            label: Text("Tipo de productos"),
            prefixIcon: Icon(Icons.food_bank)
      ),
      onChanged: (value) async {
        Producto? producto = await showDialog<Producto>(
          context: context,
          builder: (context) => AddProductDialog(optionSelected: value.toString()),
        );
        if(producto != null){
          setState(() {
            _listTypeProducts.add(value!);
            _listProducts[value] ??= [];
            _listProducts[value]!.add(producto);
            _cantidadTotal += producto.peso;
          }
        );
        }
      },
    );
  }

  Widget _wrapElements(){
    if(_listTypeProducts.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        const SizedBox(height: 10),
        Wrap(
          runSpacing: 10,
          spacing: 13,
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          children: _listTypeProducts.map((e) => InputChip(
            onSelected: (value) async {
              await _showProductsAddedDialog(context, e);
              setState(() {
                if(_listProducts[e]!.isEmpty) {
                  _listTypeProducts.remove(e);
                  _listProducts.remove(e);
                }
              });
            },
            onDeleted: () async {
              bool? delete = await _deleteGroupTypeProductsDialog(context, e);
              if(delete!){
                setState(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$e eliminado"),
                    backgroundColor: Colors.red, duration:
                    const Duration(seconds: 2)
                  ));
                  _cantidadTotal -= _listProducts[e]!.fold<double>(0, (prev, product) => prev + product.peso);
                  _listProducts.remove(e);
                  _listTypeProducts.remove(e);
                });
              }
            },
            labelPadding: const EdgeInsets.all(2),
            label: Text(e),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          )).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [  
            _wrapElements(),
            const SizedBox(height: 10),
            _dropDownProducts(),
            Text(
              "Peso total: ${_cantidadTotal.toStringAsFixed(2)} kg"
            ),
            const SizedBox(height: 10),
          ],
        );
  }
}