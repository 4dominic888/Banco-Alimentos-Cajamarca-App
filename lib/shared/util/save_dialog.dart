import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';

Map<String, String> mapMimeType = {
  'pdf': 'application/pdf',
  'xlsx': 'application/vnd.ms-excel'
};

class SaveDialog{

  static Future<bool> onDownloadDir(List<int> bytes, {required String dialogTitle, required String filename, required String ext}) async{
    final Directory? downloadDir;
    bool isFilePickerPackage;
    if(Platform.isAndroid){
      downloadDir = await getExternalStorageDirectory() ;
      isFilePickerPackage = true;
    }
    else if(Platform.isWindows){
      downloadDir = await getDownloadsDirectory();
      isFilePickerPackage = true;
    }
    else if(Platform.isLinux){
      downloadDir = await getDownloadsDirectory();
      isFilePickerPackage = false;
    }
    else{
      downloadDir = Directory('/');
      isFilePickerPackage = true;
    }

    if(isFilePickerPackage){
      final String? result = await FilePicker.platform.saveFile(
        lockParentWindow: true,
        dialogTitle: dialogTitle,
        fileName: '${filename.replaceAll(' ', '-')}.$ext',
        type: FileType.custom,
        allowedExtensions: [ext],
        initialDirectory: downloadDir!.path,
      );

      if(result != null){
        final File file = File(result);
        file.writeAsBytes(bytes);
        return true;
      }
      return false;
    }
    else{
      final FileSaveLocation? result = await getSaveLocation(
        suggestedName: '${filename.replaceAll(' ', '-')}.$ext',
        initialDirectory: downloadDir!.path,
        confirmButtonText: 'Guardar'
      );

      if(result != null){
        final Uint8List fileData = Uint8List.fromList(bytes);
        final XFile file = XFile.fromData(fileData, name: '${filename.replaceAll(' ', '-')}.$ext', mimeType: mapMimeType[ext]);
        await file.saveTo(result.path);
        return true;
      }
      return false;
    }
  }
}