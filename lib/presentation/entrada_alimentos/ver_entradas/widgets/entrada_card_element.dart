import 'package:bancalcaj_app/domain/models/entrada.dart';
import 'package:bancalcaj_app/domain/services/entrada_alimentos_service_base.dart';
import 'package:bancalcaj_app/infrastructure/excel_writter.dart';
import 'package:bancalcaj_app/infrastructure/pdf_writter.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/agregar_entrada/screens/agregar_entrada_screen.dart';
import 'package:bancalcaj_app/presentation/widgets/notification_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class EntradaCardElement extends StatelessWidget {
  const EntradaCardElement({
    super.key,
    required this.entradaView,
    required ExcelWritter excelService,
    required PDFWritter pdfService, this.onDataUpdate,
  }) : _excelService = excelService, _pdfService = pdfService;

  final EntradaView entradaView;
  final ExcelWritter _excelService;
  final PDFWritter _pdfService;
  final void Function()? onDataUpdate;

  @override
  Widget build(BuildContext context) {
    final RoundedLoadingButtonController btnControllerExcel = RoundedLoadingButtonController();
    final RoundedLoadingButtonController btnControllerPdf = RoundedLoadingButtonController();
    return Card(
      child: ListTile(
        title: Text("${entradaView.proveedor ?? '-'} / ${entradaView.cantidadStr}kg\n${DateFormat("dd/MM/yyyy HH:mm").format(entradaView.fecha)}"),
        leading: Column(
          children: [
            const Icon(Icons.account_box_sharp),
            Text(entradaView.almacenero ?? '-')
          ],
        ),
        subtitle: SizedBox(
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 5,
            runSpacing: 5,
            children: entradaView.productos.map((e) => InputChip(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              label: Text(e, style: const TextStyle(fontSize: 12)),
              onPressed: () {}
            )).toList(),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            //* Excel Export
            RoundedLoadingButton(
              color: Colors.green,
              errorColor: Colors.green,
              controller: btnControllerExcel,
              width: 120,
              child: SizedBox(width: 70, child: Row(
                  children: [
                    SvgPicture.asset('assets/svg/microsoft_excel_icon.svg', width: 24, height: 24, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                    const Spacer(),
                    const Text("Excel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              onPressed: () async {
                //? Si hubiera mas logica compleja o mas botones similares, refactorizar
                final entradaResult = await GetIt.I<EntradaAlimentosServiceBase>().seleccionarEntrada(entradaView.id);
                if(!entradaResult.success) {
                  NotificationMessage.showErrorNotification(entradaResult.message!);
                  btnControllerExcel.error();
                  return;
                }
                else{
                  if(entradaResult.data!.proveedor == null) {
                    NotificationMessage.showErrorNotification('La entrada tiene un proveedor que ya no existe');
                    btnControllerExcel.error();
                    await Future.delayed(const Duration(seconds: 3));
                    btnControllerExcel.reset();
                    return;
                  }
                  if(entradaResult.data!.almacenero == null) {
                    NotificationMessage.showErrorNotification('La entrada tiene un almacenero que ya no existe');
                     btnControllerExcel.error();
                    await Future.delayed(const Duration(seconds: 3));
                    btnControllerExcel.reset();
                    return;
                  }                  
                  await _excelService.printEntradaExcel(entradaResult.data!);
                  btnControllerExcel.success();
                }
                btnControllerExcel.reset();
              },
            ),

            const SizedBox(width: 10),

            //* PDF Export
            RoundedLoadingButton(
              color: Colors.red,
              controller: btnControllerPdf,
              width: 110,
              child: const SizedBox(
                width: 60,
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.white),
                    Spacer(),
                    Text("PDF", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              onPressed: () async {
                //? Si hubiera mas logica compleja o mas botones similares, refactorizar
                final entradaResult = await GetIt.I<EntradaAlimentosServiceBase>().seleccionarEntrada(entradaView.id);
                if(!entradaResult.success) {
                  NotificationMessage.showErrorNotification(entradaResult.message!);
                  btnControllerPdf.error();
                  return;
                }
                else{
                  if(entradaResult.data!.proveedor == null) {
                    NotificationMessage.showErrorNotification('La entrada tiene un proveedor que ya no existe');
                    btnControllerPdf.error();
                    await Future.delayed(const Duration(seconds: 3));
                    btnControllerPdf.reset();
                    return;
                  }
                  if(entradaResult.data!.almacenero == null) {
                    NotificationMessage.showErrorNotification('La entrada tiene un almacenero que ya no existe');
                    btnControllerPdf.error();
                    await Future.delayed(const Duration(seconds: 3));
                    btnControllerPdf.reset();
                    return;
                  }
                  await _pdfService.printEntradaPDF(entradaResult.data!);
                  btnControllerPdf.success();
                }
                btnControllerPdf.reset();
              },
            ),
          
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 0, child: Text('Actualizar')),
                const PopupMenuItem(value: 1, child: Text('Eliminar'))                
              ],
              onSelected: (value) async {
                switch (value) {
                  case 0: {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AgregarEntradaScreen(idEntradaToEdit: entradaView.id)))
                      .then((_) => onDataUpdate?.call());
                    break;
                  }

                  case 1: {
                    final RoundedLoadingButtonController btnConfirmController = RoundedLoadingButtonController();
                    showDialog(context: context, builder: (dialogContext) => AlertDialog(
                      title: const Text('Eliminar Entrada'),
                      content: const Text('Esta seguro que desea eliminar esta entrada de alimentos'),
                      actions: [
                        SizedBox(
                          width: 120,
                          height: 50,
                          child: RoundedLoadingButton(
                            controller: btnConfirmController,
                            child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
                            color: Colors.red,
                            width: 120,
                            onPressed: () async {
                              final result = await GetIt.I<EntradaAlimentosServiceBase>().eliminarEntrada(entradaView.id);
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

                  default: break;
                }
              },
            )
          ],
        )
      ),
    );
  }
}