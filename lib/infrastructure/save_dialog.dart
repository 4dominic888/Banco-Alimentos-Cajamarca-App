import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_file_saver/simple_file_saver.dart';

Map<String, String> mapMimeType = {
  'pdf': 'application/pdf',
  'xlsx': 'application/vnd.ms-excel'
};

enum _SaveFileType{
  filePicker,
  fileSelector,
  simpleFileSaver
}

class SaveDialog{

  static Future<bool> onDownloadDir(List<int> bytes, {required String dialogTitle, required String filename, required String ext}) async{
    final Directory? downloadDir;
    _SaveFileType saveFileType;
    if(Platform.isAndroid){

      // //*C permiso
      // final status = await Permission.manageExternalStorage.status;
      // if(!status.isGranted) {
      //   await Permission.storage.request();
      // }

      // if(await Permission.manageExternalStorage.isGranted) {
        downloadDir = await getExternalStorageDirectory();
        saveFileType = _SaveFileType.simpleFileSaver;
      // }
      // else {return false;}

    }
    else if(Platform.isWindows){
      downloadDir = await getDownloadsDirectory();
      saveFileType = _SaveFileType.filePicker;
    }
    else if(Platform.isLinux){
      downloadDir = await getDownloadsDirectory();
      saveFileType = _SaveFileType.fileSelector;
    }
    else{
      downloadDir = Directory('/');
      saveFileType = _SaveFileType.filePicker;
    }

    switch (saveFileType) {
      case _SaveFileType.filePicker: {
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
      case _SaveFileType.fileSelector: {
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

      case _SaveFileType.simpleFileSaver: {
        final Uint8List fileData = Uint8List.fromList(bytes);
        final result = await SimpleFileSaver.saveFile(fileInfo: FileSaveInfo.fromBytes(
          bytes: fileData,
          basename: filename.replaceAll(' ', '-'),
          extension: ext,
        ), saveAs:  true);

        return result != null;
      }
        
      default: throw Exception('No file selector type selected');
    }
    
  }
}