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
    required PDFWritter pdfService,
  }) : _excelService = excelService, _pdfService = pdfService;

  final EntradaView entradaView;
  final ExcelWritter _excelService;
  final PDFWritter _pdfService;

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
              spacing: 10,
              runSpacing: 10,
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
                  await _excelService.printEntradaExcel(entradaResult.data!);
                  btnControllerExcel.success();
                }
                await Future.delayed(const Duration(seconds: 1));
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
                  await _pdfService.printEntradaPDF(entradaResult.data!);
                  btnControllerPdf.success();
                }
                await Future.delayed(const Duration(seconds: 1));
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AgregarEntradaScreen(idEntradaToEdit: entradaView.id)));
                    break;
                  }

                  case 1: {
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