import 'dart:io';

import 'package:bancalcaj_app/domain/models/update_data.dart';
import 'package:bancalcaj_app/presentation/widgets/notification_message.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdaterPopup extends StatefulWidget {

  final UpdateData data;

  const UpdaterPopup({super.key, required this.data});

  @override
  State<UpdaterPopup> createState() => _UpdaterPopupState();
}

class _UpdaterPopupState extends State<UpdaterPopup> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.data.title),
      content: SingleChildScrollView(
        child: ListBody(children: [
          const Text('Hay una nueva actualización disponible, siga los pasos de abajo para proceder a instalar la nueva versión\n'),

          if(Platform.isWindows) const Text('Para Windows', style: TextStyle(fontWeight: FontWeight.bold)),
          if(Platform.isWindows) const Text('Haga click en Actualizar, luego descargue el archivo .zip, proceda a descomprimirlo para obtener la carpeta resultante, dicha carpeta contendra la nueva versión. (Luego se puede borrar la carpeta actual si lo desea)'),
          if(Platform.isAndroid) const Text('Para Android', style: TextStyle(fontWeight: FontWeight.bold)),
          if(Platform.isAndroid) const Text('Haga click en Actualizar, luego descargue el archivo .apk, proceda a ejecutarlo para actualizar la aplicación. (Luego se puede borrar dicho archivo si lo desea)'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(),
          ),
          const Text('Cambios', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(widget.data.description)
        ])
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar')
        ),
        TextButton(
          onPressed: () async {
            final url = Uri.parse(widget.data.asset.url);
            if(await canLaunchUrl(url)) { await launchUrl(url); }
            else { NotificationMessage.showErrorNotification('Error al descargar la actualización'); }
            if(!context.mounted) return;
            Navigator.of(context).pop();
          },
          child: Text('Actualizar (${widget.data.asset.size})')
        )
      ],
    );
  }
}