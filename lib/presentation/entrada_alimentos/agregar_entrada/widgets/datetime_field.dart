import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeField extends StatefulWidget {
  
  final String label;
  final DateTime? initialValue;
  final Key formFieldKey;

  const DateTimeField({super.key, required this.label, required this.formFieldKey, this.initialValue});

  @override
  State<DateTimeField> createState() => DateTimeFieldState();
}

class DateTimeFieldState extends State<DateTimeField> {
    
  DateTime _fecha = DateTime.now();

  //? Método para obtener la fecha mediante un popup
  Future<void> _selectDate(BuildContext context, FormFieldState<DateTime> formState) async {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      cancelText: localizations.cancelButtonLabel,
      confirmText: localizations.okButtonLabel,
      helpText: localizations.datePickerHelpText,
      builder: (BuildContext context, Widget? child) => Theme(data: ThemeData.light(), child: child!)
    );

    if(picked != null && picked != _fecha) {
      if(!context.mounted) return;
      final TimeOfDay? selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

      if(selectedTime != null){
        setState(() {
          _fecha = DateTime(
            picked.year, picked.month, picked.day,
            selectedTime.hour, selectedTime.minute
          );
        });
        formState.didChange(_fecha);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: widget.initialValue ?? DateTime.now(),
      key: widget.formFieldKey,
      builder: (formState) {
        return GestureDetector(
          onTap: () => _selectDate(context, formState),
          child: AbsorbPointer(
            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(label: Text(widget.label), prefixIcon: const Icon(Icons.date_range)),
              controller: TextEditingController(text: DateFormat('yyyy-MM-dd  HH:mm').format(_fecha)),
            ),
          ),
        );
      }
    );
  }
}