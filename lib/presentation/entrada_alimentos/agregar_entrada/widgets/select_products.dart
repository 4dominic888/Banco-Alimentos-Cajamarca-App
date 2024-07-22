import 'dart:collection';

import 'package:bancalcaj_app/domain/classes/producto.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/agregar_entrada/screens/add_product_dialog.dart';
import 'package:flutter/material.dart';

class SelectProductsField extends StatefulWidget {

  final List<String> defaultCommonProducts;
  final List<TipoProductos>? initialValue;
  final Key formFieldKey;
  
  const SelectProductsField({
    super.key,
    required this.defaultCommonProducts,
    required this.formFieldKey,
    this.initialValue
  });

  @override
  State<SelectProductsField> createState() => SelectProductsFieldState();
}

class SelectProductsFieldState extends State<SelectProductsField> {

  final List<String> _listSelect = [];
  final List<TipoProductos> _listProducts = [];
  final HashSet<String> _stringProducts = HashSet();

  double _cantidadTotal = 0.00;
  double get cantidadTotal => _cantidadTotal;

  @override
  void initState() {
    super.initState();
    _listSelect.addAll([...widget.defaultCommonProducts, 'Otros']);
  }

  Future<void> _showProductsAddedDialog(BuildContext context, String optionSelected, int foundIndex, FormFieldState<List<TipoProductos>> formState) async{
    if(foundIndex == -1) return;

    return showDialog(context: context, builder: (context) => AlertDialog(
      scrollable: true,
      title: Text("Productos agregados de tipo: $optionSelected"),
      content: StatefulBuilder(
        builder: (context, setState) {
          if(_listProducts[foundIndex].productos.isEmpty) return const Center(child: Text("No hay productos"));
          return SizedBox(
            height: 300, width: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _listProducts[foundIndex].productos.length,
              itemBuilder: (context, index) {
                final element = _listProducts[foundIndex].productos[index];
                return ListTile(
                  title: Text(element.nombre),
                  subtitle: Text("${element.peso.toString()} kg"),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      //* Para cerrar
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Producto eliminado"),
                            backgroundColor: Colors.red, duration:
                            Duration(seconds: 2)
                          )
                        );
                        _cantidadTotal -= element.peso;
                        _listProducts[foundIndex].productos.removeAt(index);
                        formState.didChange(_listProducts);
                      });
                    },
                  ),
                );
              }, 
            )
          );
        }
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

  Widget _dropDownProducts(FormFieldState<List<TipoProductos>> formState) {
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
            _stringProducts.add(value!);

            final foundIndex = _listProducts.indexWhere((e) => e.nombre == value);
            if(foundIndex == -1) {
              _listProducts.add(TipoProductos(nombre: value, productos: [producto]));
            }
            else {
              _listProducts[foundIndex].productos.add(producto);
            }
            formState.didChange(_listProducts);
            _cantidadTotal += producto.peso;
          });
        }
      },
    );
  }

  Widget _wrapElements(FormFieldState<List<TipoProductos>> formState){
    if(_stringProducts.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        const SizedBox(height: 10),
        Wrap(
          runSpacing: 10,
          spacing: 13,
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          children: _stringProducts.map((e) => InputChip(
            onSelected: (value) async {
              final foundIndex = _listProducts.indexWhere((element) => element.nombre == e);
              await _showProductsAddedDialog(context, e, foundIndex, formState);
              setState(() {
                if(_listProducts[foundIndex].productos.isEmpty) {
                  _stringProducts.remove(e);
                  _listProducts.removeAt(foundIndex);
                }
              });
            },
            onDeleted: () async {
              bool? delete = await _deleteGroupTypeProductsDialog(context, e);
              if(delete!){
                final foundIndex = _listProducts.indexWhere((element) => element.nombre == e);
                setState(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$e eliminado"),
                    backgroundColor: Colors.red, duration:
                    const Duration(seconds: 2)
                  ));
                  _cantidadTotal -= _listProducts[foundIndex].productos.fold<double>(0, (prev, product) => prev + product.peso);
                  _listProducts.removeAt(foundIndex);
                  formState.didChange(_listProducts);
                  _stringProducts.remove(e);
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
    return FormField<List<TipoProductos>>(
      key: widget.formFieldKey,
      initialValue: widget.initialValue ?? [],
      validator: (value) {
        if(value == null || value.isEmpty) return 'Se debe proporcionar productos';
        return null;
      },
      builder: (formState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [  
            _wrapElements(formState),
            const SizedBox(height: 10),
            _dropDownProducts(formState),
            Text("Peso total: ${_cantidadTotal.toStringAsFixed(2)} kg"),
            const SizedBox(height: 10),
          ]
        );
      }
    );
  }
}