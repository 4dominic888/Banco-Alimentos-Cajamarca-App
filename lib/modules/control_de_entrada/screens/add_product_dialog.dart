import 'package:bancalcaj_app/modules/control_de_entrada/classes/producto.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/widgets/auto_completed_field.dart';
import 'package:bancalcaj_app/modules/control_de_entrada/widgets/decimal_field.dart';
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
  ];

  static const List<String> _frutaRecommend = [
    "Frutas de hueso (duraznos, ciruelas, cerezas, albaricoques)",
    "Bayas (fresa, frambruesa, arandanos, uvas)",
    "Citricos (naranjas, limones, limas, mandarinas, pomelos)",
    "Frutas tropicales (piñas, mangos, papayas, platanos, kiwis)",
    "Frutas de pepita (manzanas, peras, membrillos)",
    "Frutas de cascara gruesa o dura (cocos, piñas, nuez de coco)",
    "Frutas exoticas (carambola, pitahaya)"
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
    "Harina",
    "Quinua",
    "Otros embutidos(Harina, quinua, maiz perla, maiz serrano, avena)",
    "Menestras",
    "Semillas y frutos secos (pecanas, mani, cereales, semillas de girasol)",
    "Leche y otros productos lácteos (leche fresca, queso, mantequilla, manjar blanco)",
    "Aceite/grasas",
    "Azucar o dulce (azucar, miel, estevia, mermeladas, etc)",
    "Condimentos/especias/bebidas (sal, cafe, infusiones, canela, etc)",
    "Salsas",

  ];

  static const List<String> _embutidoRecommend = [
    "Embutidos frescos (salchichas, longanizas, chorizos frescos)",
    "Embutidos curados (salami, jamón cocido)",
    "Embutidos ahumados (salchichas ahumadas, pepperoni, salchichón)"
  ];

  static const List<String> _otroRecommend = [
    "Huevos",
    "Alimentos cocidos/precocidos",
    "Bebidas (gaseosas, nectar, refrescos)",
    "Agua",
    "Confiterias/golosinas (galletas, chocolates, caramelos, etc)"
    "Panaderia y pasteleria (pan, pasteles, kekes, alfajores)"
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
                  grupoAliementos: keyProductName.currentState!.text,
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