import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeField extends StatefulWidget {
  const DateTimeField({super.key, required this.label});

  final String label;

  @override
  State<DateTimeField> createState() => DateTimeFieldState();
}

class DateTimeFieldState extends State<DateTimeField> {
    
    DateTime _fecha = DateTime.now();
    DateTime get fecha => _fecha;

    //? Método para obtener la fecha mediante un popup
    Future<void> _selectDate(BuildContext context) async{
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      cancelText: localizations.cancelButtonLabel,
      confirmText: localizations.okButtonLabel,
      helpText: localizations.datePickerHelpText,
      builder: (BuildContext context, Widget? child){
        return Theme(data: ThemeData.light(), child: child!);
      }
    );
    if(picked != null && picked != _fecha){
      setState(() {
        _fecha = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              label: Text(widget.label),
              prefixIcon: const Icon(Icons.date_range)
            ),
            controller: TextEditingController(
              text: DateFormat('yyyy-MM-dd').format(_fecha)
            ),
          ),
        ),
    );
  }
}