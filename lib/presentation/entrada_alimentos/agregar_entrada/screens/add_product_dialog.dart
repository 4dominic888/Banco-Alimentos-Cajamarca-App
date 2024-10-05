import 'package:bancalcaj_app/domain/classes/producto.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/agregar_entrada/widgets/auto_completed_field.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/agregar_entrada/widgets/decimal_field.dart';
import 'package:flutter/material.dart';

//TODO Remover esta clase y cambiarla por una llamada a algun archivo o base de datos
class _RecommendedProducts{
  static List<String> list(String typeProduct){
    switch (typeProduct) {
      case "Carnes": return _carneRecommend;
      case "Frutas": return _frutaRecommend;
      case "Verduras": return _verduraRecommend;
      case "Abarrotes": return _abarroteRecommend;
      case "Embutidos": return _embutidoRecommend;
      case "Otros": return _otroRecommend;
      default: return _otroRecommend;
    }
  }

  static const List<String> _carneRecommend = [
    "Carnes rojas (res, chancho)",
    "Carnes blancas (aves)",
    "Menudencia",
    "Pescados y mariscos",
    "Huevos"
  ];

  static const List<String> _frutaRecommend = [
    "Frutas"
  ];

  static const List<String> _verduraRecommend = [
    "Vegetales y hojas (verduras, hongos, champiñones, otros)"
  ];

  static const List<String> _abarroteRecommend = [
    "Arroz",
    "Fideo",
    "Papa",
    "Yuca",
    "Camote",
    "Otros almidones(Harina, quinua, maiz perla, maiz serrano, avena, etc)",
    "Menestras",
    "Semillas y frutos secos (pecanas, mani, cereales, semillas de girasol)",
    "Leche y otros productos lácteos (leche fresca, queso, mantequilla, manjar blanco, otros)",
    "Aceite/grasas",
    "Azucar o dulce (azucar, miel, estevia, mermeladas, etc)",
    "Condimentos/especias/bebidas (sal, cafe, infusiones, canela, etc)",
    "Salsas",
    "Bebidas (Gaseosas, néctar, refrescos)",
    "Agua"
  ];

  static const List<String> _embutidoRecommend = [
    "Embutidos",
  ];

  static const List<String> _otroRecommend = [
    "Alimentos cocidos/precocidos",
    "Bebidas (gaseosas, nectar, refrescos)",
    "Agua",
    "Confiterias/golosinas (galletas, chocolates, caramelos, etc)",
    "Panadería y pastelería (pan, pasteles, kekes, alfajores)",
    "Alimentos cocidos/precocidos"
  ];
}

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key, required this.optionSelected});

  final String optionSelected;

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  @override
  Widget build(BuildContext context) {

    List<String> data = _RecommendedProducts.list(widget.optionSelected);

    final GlobalKey<FormState> formKey = GlobalKey();
    final GlobalKey<AutoCompleteFieldState> keyProductName = GlobalKey();
    final GlobalKey<DecimalFieldState> keyFieldPeso = GlobalKey();

    return AlertDialog(
        title: Text("Agrega el producto de tipo: ${widget.optionSelected}"),
        scrollable: true,
        content: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoCompleteField(
                key: keyProductName,
                title: "Producto",
                recommends: data,
              ),
              
              DecimalField(
                key: keyFieldPeso,
                label: "Peso",
                suffixText: "kg"
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text("Cancelar")
          ),

          TextButton(
            onPressed: () {
              if(formKey.currentState!.validate()){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Procuto de tipo \"${widget.optionSelected}\" agregado "),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ));
                
                Navigator.of(context).pop(Producto(
                  nombre: keyProductName.currentState!.text,
                  peso: keyFieldPeso.currentState!.cantidad
                ));
              }
            },
            child: const Text("Aceptar")
          ),
        ],
      );
  }
}