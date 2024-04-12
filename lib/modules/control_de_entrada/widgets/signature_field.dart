import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureField extends StatefulWidget {
  const SignatureField({super.key, required this.titleModal, required this.title});

  final String titleModal;
  final String title;

  @override
  State<SignatureField> createState() => SignatureFieldState();
}

class SignatureFieldState extends State<SignatureField>{

  Uint8List? _signatureImage;

  String get signature => base64Encode(_signatureImage!);

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.blue.shade700,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.blue.shade700
  );

  Future<Uint8List?> _showSignatureDialog(BuildContext context){
    Uint8List? generatedSignature;
    return showDialog<Uint8List>(
      context: context, builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text(widget.titleModal),
          content: Signature(
            controller: _controller,
            width: 350,
            height: 200,
            backgroundColor: Colors.grey.shade300,
          ),
          actions: [
            TextButton(
              child: const Text("Aceptar"),
              onPressed: () async {
                generatedSignature = await _controller.toPngBytes();
                setState(() => Navigator.of(context).pop(generatedSignature));
              },
            ),
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: const Text("Limpiar"),
              onPressed: () {
                _controller.clear();
              },
            ),
          ],
        );
      }
    );
  }

  Widget _showImageSignature(){
    if(_signatureImage != null) return Image.memory(_signatureImage!);
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<Uint8List>(
      validator: (value) {
        if(_signatureImage == null) return "No se ha ingresado la firma";
        return null;
      },
      builder: (field) => 
      InputDecorator(
        decoration: InputDecoration(
            labelText: widget.title,
            labelStyle: const TextStyle(fontSize: 22),
            border: InputBorder.none
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                _signatureImage = await _showSignatureDialog(context);
                setState(() {});
              },                  
              child: Container(
                      width: 300,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(
                          color: Colors.black,
                          width: 2
                        )
                      ),
                      child: _showImageSignature(),
                ),
            ),
          ],
        ),
        ),
    );
  }

}