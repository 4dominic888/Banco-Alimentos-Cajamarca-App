import 'package:bancalcaj_app/modules/proveedor_module/classes/ubication.dart';
import 'package:bancalcaj_app/modules/proveedor_module/widgets/controllers/radio_button_list_controller.dart';
import 'package:bancalcaj_app/modules/proveedor_module/widgets/controllers/ubication_field_controller.dart';
import 'package:bancalcaj_app/modules/proveedor_module/widgets/international_ubication_field.dart';
import 'package:bancalcaj_app/modules/proveedor_module/widgets/national_ubication_field.dart';
import 'package:bancalcaj_app/modules/proveedor_module/widgets/radio_button_list.dart';
import 'package:flutter/material.dart';

class UbicationFormField extends StatefulWidget {
  
  final String? Function(Ubication?)? validator;
  final Key formFieldKey;

  const UbicationFormField({super.key, this.validator, required this.formFieldKey});

  @override
  State<UbicationFormField> createState() => _UbicationFormFieldState();
}

class _UbicationFormFieldState extends State<UbicationFormField> {

  final RadioButtonListController _radioButtonListController = RadioButtonListController();
  final UbicationFieldController _ubicationFieldController = UbicationFieldController();

  late void Function() _listener;

  @override
  Widget build(BuildContext context) {
    return FormField<Ubication>(
      key: widget.formFieldKey,
      builder: (formState) {
        _listener = () {
          formState.didChange(_ubicationFieldController.ubication);
        };

        _ubicationFieldController.addListener(_listener);

        return InputDecorator(
          decoration: InputDecoration(
            label: const Text("Ubicacion del proveedor"),
            icon: const Icon(Icons.map),
            border: InputBorder.none,
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red)
            ),
            errorText: formState.hasError ? formState.errorText ?? '' : null,
          ),
          child: Column(
            children: [
              RadioButtonList(
                controller: _radioButtonListController,
                options: const ['Nacional', 'Internacional'],
                onChanged: () {
                  setState(() {
                    _ubicationFieldController.clear();
                    formState.didChange(null);
                  });
                },
              ),
          
              if(_radioButtonListController.selectedIndex == 0) NationalUbicationField(controller: _ubicationFieldController)
              else InternationalUbicationField(controller: _ubicationFieldController)
            ],
          ),
        );
      },
      validator: widget.validator!,
    );
  }

  @override
  void dispose() {
    _radioButtonListController.dispose();
    _ubicationFieldController.removeListener(_listener);
    _ubicationFieldController.dispose();
    super.dispose();
  }
}