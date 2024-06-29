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
  final Ubication? initialData;

  const UbicationFormField({super.key, this.validator, required this.formFieldKey, this.initialData});

  @override
  State<UbicationFormField> createState() => _UbicationFormFieldState();
}

class _UbicationFormFieldState extends State<UbicationFormField> {

  late final RadioButtonListController _radioButtonListController;
  late final UbicationFieldController _ubicationFieldController;

  late void Function() _listener;

  @override
  void initState() {
    super.initState();
    _ubicationFieldController = UbicationFieldController();
    _radioButtonListController = RadioButtonListController(
      widget.initialData?.type == 'international' ? 1 : 0
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<Ubication>(
      initialValue: widget.initialData,
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
                initialIndexValue: _radioButtonListController.selectedIndex,
                controller: _radioButtonListController,
                options: const ['Nacional', 'Internacional'],
                onChanged: () {
                  setState(() {
                    _ubicationFieldController.clear();
                    formState.didChange(null);
                  });
                },
              ),
          
              if(_radioButtonListController.selectedIndex == 0) NationalUbicationField(controller: _ubicationFieldController, initialData: widget.initialData)
              else InternationalUbicationField(controller: _ubicationFieldController, initialData: widget.initialData)
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