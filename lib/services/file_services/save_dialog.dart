import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class SaveDialog{



  static Future<bool> onDownloadDir(List<int> bytes, {required String dialogTitle, required String filename, required String ext}) async{
    final Directory? downloadDir;
    if(Platform.isAndroid){
      downloadDir = await getExternalStorageDirectory() ;
    }
    else if(Platform.isWindows){
      downloadDir = await getDownloadsDirectory();
    }
    else{
      downloadDir = Directory('/');
    }

    final String? result = await FilePicker.platform.saveFile(
      dialogTitle: dialogTitle,
      fileName: '$filename.$ext',
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
}