import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/presentation/proveedores/agregar_proveedor/screens/agregar_proveedor_screen.dart';
import 'package:flutter/material.dart';

class ProveedorElement extends StatelessWidget {

  final ProveedorView proveedor;
  final void Function()? onTap;
  final Widget? leading;
  final void Function()? onDataUpdate;

  const ProveedorElement({super.key, required this.proveedor, this.onTap, this.leading, this.onDataUpdate});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(proveedor.nombre),
      subtitle: Text(proveedor.typeProveedor),
      onTap: onTap,
      leading: leading,
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(value: 0, child: Text('Editar'),)
        ],
        onSelected: (value) async {
          switch (value) {
            case 0: Navigator.of(context).push(MaterialPageRoute(builder: (context) => AgregarProveedorScreen(
              idProveedorToEdit: proveedor.id,
            ))).then((value) => onDataUpdate?.call());
            default: return;
          }
        },
      )
    );
  }
}