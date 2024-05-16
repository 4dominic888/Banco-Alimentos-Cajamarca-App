import 'package:bancalcaj_app/modules/proveedor_module/widgets/controllers/radio_button_list_controller.dart';
import 'package:flutter/material.dart';

class RadioButtonList extends StatefulWidget {

  final List<String> options;
  final RadioButtonListController? controller;
  final void Function()? onChanged;
  const RadioButtonList({super.key, required this.options, this.controller, this.onChanged});

  @override
  State<RadioButtonList> createState() => _RadioButtonListState();
}

class _RadioButtonListState extends State<RadioButtonList> {
  
  late int currentOption = widget.options.indexOf(widget.options.first);
  
  @override
  Widget build(BuildContext context) {
    return FormField(builder: (field) {
        //TODO: Hacer que sea dinamico, entre row, column, etc si fuera necesario.
        return Row(
          children: widget.options.map((e) => Expanded(
            child: ListTile(
              title: Text(e),
              leading: Radio<int>(
                value: widget.options.indexOf(e),
                groupValue: currentOption,
                onChanged: (value) {
                  setState(() {
                    currentOption = value!;
                    widget.controller?.setValue = currentOption;
                  });
                  widget.onChanged?.call();
                },
              ),
            ),
          )).toList()
        );
    });
  }
}