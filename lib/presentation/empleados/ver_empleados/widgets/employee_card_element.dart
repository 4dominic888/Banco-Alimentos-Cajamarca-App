import 'package:bancalcaj_app/domain/models/employee.dart';
import 'package:bancalcaj_app/domain/services/employee_service_base.dart';
import 'package:bancalcaj_app/presentation/empleados/editar_cuenta/screens/editar_cuenta_screen.dart';
import 'package:bancalcaj_app/presentation/widgets/notification_message.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class EmployeeCardElement extends StatelessWidget {

  final void Function()? onDataUpdate;
  final EmployeeView employeeView;

  const EmployeeCardElement({
    super.key,
    required this.employeeView,
    this.onDataUpdate
  });


  @override
  Widget build(BuildContext context) {
    final btnEditController = RoundedLoadingButtonController();
    final btnDeleteController = RoundedLoadingButtonController();
    return Card(
      child: ListTile(
        title: Text(employeeView.nombre),
        leading: Column(
          children: [
            const Icon(Icons.person),
            Text(employeeView.dni),
          ],
        ),
        subtitle: SizedBox(
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 10, runSpacing: 10,
            children: employeeView.types.map((e) => InputChip(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              label: Text(e, style: const TextStyle(fontSize: 12)),
              onPressed: () {}
            )).toList(),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            //* Editar empleado
            RoundedLoadingButton(
              color: Colors.lightBlue,
              controller: btnEditController,
              width: 120,
              child: const SizedBox(width: 80,
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.white), Spacer(),
                    Text("Editar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              onPressed: () async {
                final result = await GetIt.I<EmployeeServiceBase>().seleccionarEmpleado(employeeView.dni);
                if(!result.success){
                  NotificationMessage.showErrorNotification(result.message);
                  return;
                }
        
                if(!context.mounted) return;
        
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditarCuentaScreen(employee: result.data!, superEdit: true)))
                  .then((_) => onDataUpdate?.call());                
              },
            ),

            const SizedBox(width: 10),

            //* Eliminar empleados con popup
            RoundedLoadingButton(
              color: Colors.red,
              controller: btnDeleteController,
              width: 120,
              child: const SizedBox(
                width: 90,
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    Spacer(),
                    Text("Eliminar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              onPressed: () async {
                final RoundedLoadingButtonController btnConfirmController = RoundedLoadingButtonController();
                showDialog(context: context, builder: (dialogContext) => AlertDialog(
                  title: const Text('Eliminar Empleado'),
                  content: const Text('Esta seguro que desea eliminar este empleado, esta accion no puedes revertir'),
                  actions: [
                    SizedBox(width: 120, height: 50,
                      child: RoundedLoadingButton(
                        controller: btnConfirmController,
                        child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
                        color: Colors.red,
                        width: 120,
                        onPressed: () async {
                          final result = await GetIt.I<EmployeeServiceBase>().eliminarEmpleado(employeeView.dni);
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

                    SizedBox(width: 120, height: 50,
                      child: ElevatedButton(
                        child: const Text('Cancelar'),
                        style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white), foregroundColor: WidgetStatePropertyAll(Colors.black)),
                        onPressed: () => Navigator.of(context).pop()
                      ),
                    ),
                  ],
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}