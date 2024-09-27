import 'dart:io';

import 'package:bancalcaj_app/data/backend/express_backend.dart';
import 'package:bancalcaj_app/domain/models/update_data.dart';
import 'package:bancalcaj_app/domain/repositories/updater_repository_base.dart';
import 'package:package_info_plus/package_info_plus.dart';

interface class UpdaterRepositoryImplement extends UpdaterRepositoryBase {

  @override
  Future<E> getUpdate() async {

    final os = Platform.isAndroid ? 'Android' :
               Platform.isWindows ? 'Windows' : 
               'none';

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;

    final data = await ExpressBackend.solicitude('get-update', RequestType.get, queryParameters: {
      'os': os,
      'version': version
    });

    return UpdateData.fromJson(data);
  }

}