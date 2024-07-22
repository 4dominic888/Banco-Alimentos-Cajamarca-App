import 'package:bancalcaj_app/domain/models/proveedor.dart';
import 'package:bancalcaj_app/domain/services/proveedor_service_base.dart';
import 'package:bancalcaj_app/presentation/proveedores/agregar_proveedor/screens/agregar_proveedor_screen.dart';
import 'package:bancalcaj_app/presentation/widgets/notification_message.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

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
          const PopupMenuItem(value: 0, child: Text('Actualizar')),
          const PopupMenuItem(value: 1, child: Text('Eliminar'))
        ],
        onSelected: (value) async {
          switch (value) {
            case 0: {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AgregarProveedorScreen(idProveedorToEdit: proveedor.id,))).
                then((value) => onDataUpdate?.call());
              
              break;
            }

            case 1: {
              final RoundedLoadingButtonController btnConfirmController = RoundedLoadingButtonController();
              showDialog(context: context, builder: (dialogContext) => AlertDialog(
                title: const Text('Eliminar proveedor'),
                content: const Text('Esta seguro que desea eliminar el proveedor'),
                actions: [
                  // TextButton(child: const Text('Aceptar'), onPressed: () async {
                  //   final result = await GetIt.I<ProveedorServiceBase>().eliminarProveedor(proveedor.id);
                  //   if(dialogContext.mounted) { Navigator.of(dialogContext).pop(); }
                  //   if(!result.success) {
                  //     NotificationMessage.showErrorNotification(result.message!);
                  //     return;
                  //   }
                  //   NotificationMessage.showSuccessNotification('Se ha eliminado el proveedor con exito');
                  //   onDataUpdate?.call();
                  // }),
                                    
                  SizedBox(
                    width: 120,
                    height: 50,
                    child: RoundedLoadingButton(
                      controller: btnConfirmController,
                      child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                      width: 120,
                      onPressed: () async {
                        final result = await GetIt.I<ProveedorServiceBase>().eliminarProveedor(proveedor.id);
                        if(dialogContext.mounted) { Navigator.of(dialogContext).pop(); }
                        if(!result.success) {
                          NotificationMessage.showErrorNotification(result.message!);
                          return;
                        }
                        NotificationMessage.showSuccessNotification('Se ha eliminado el proveedor con exito');
                        onDataUpdate?.call();
                      },
                    ),
                  ),

                  SizedBox(
                    width: 120,
                    height: 50,
                    child: ElevatedButton(
                      child: const Text('Cancelar'),
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                        foregroundColor: WidgetStatePropertyAll(Colors.black)
                      ),
                      onPressed: () => Navigator.of(context).pop()
                    ),
                  ),
                ],
              ));

              break;
            }


            default: return;
          }
        },
      )
    );
  }
}