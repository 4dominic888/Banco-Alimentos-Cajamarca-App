import 'package:bancalcaj_app/domain/classes/producto.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/agregar_entrada/widgets/auto_completed_field.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/agregar_entrada/widgets/decimal_field.dart';
import 'package:flutter/material.dart';

class _RecommendedProducts{
  // static List<String> list(String typeProduct){
  //   switch (typeProduct) {
  //     case "Carnes": return _carneRecommend;
  //     case "Frutas": return _frutaRecommend;
  //     case "Verduras": return _verduraRecommend;
  //     case "Abarrotes": return _abarroteRecommend;
  //     case "Embutidos": return _embutidoRecommend;
  //     case "Otros": return _otroRecommend;
  //     default: return _otroRecommend;
  //   }
  // }

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
  ];

  static const List<String> _embutidoRecommend = [
    "Embutidos",
  ];

  static const List<String> _otroRecommend = [
    "Alimentos cocidos/precocidos",
    "Agua",
    "Confiterias/golosinas (galletas, chocolates, caramelos, etc)",
    "Panadería y pastelería (pan, pasteles, kekes, alfajores)",
  ];

  static final List<List<String>> allRecomendations = [
    _RecommendedProducts._carneRecommend,
    _RecommendedProducts._frutaRecommend,
    _RecommendedProducts._verduraRecommend,
    _RecommendedProducts._abarroteRecommend,
    _RecommendedProducts._embutidoRecommend,
    _RecommendedProducts._otroRecommend
  ];
}

class AddProductDialog extends StatefulWidget {

  final String? Function(String?)? validateNoRepetitiveProduct;

  const AddProductDialog({super.key, this.validateNoRepetitiveProduct});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  @override
  Widget build(BuildContext context) {

    List<String> data = _RecommendedProducts.allRecomendations.expand((n) => n).toList();

    final GlobalKey<FormState> formKey = GlobalKey();
    final GlobalKey<AutoCompleteFieldState> keyProductName = GlobalKey();
    final GlobalKey<DecimalFieldState> keyFieldPeso = GlobalKey();    

    return AlertDialog(
        title: const Text("Agrega producto"),
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
                validate: widget.validateNoRepetitiveProduct,
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Procuto agregado "),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
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