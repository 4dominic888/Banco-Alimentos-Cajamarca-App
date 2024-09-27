import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:bancalcaj_app/domain/models/update_data.dart';
import 'package:bancalcaj_app/domain/repositories/updater_repository_base.dart';
import 'package:bancalcaj_app/domain/services/updater_service_base.dart';

interface class UpdaterServiceImplement extends UpdaterServiceBase {

  final UpdaterRepositoryBase repo;
  UpdaterServiceImplement(this.repo);

  @override
  Future<Result<UpdateData>> obtenerActualizacion() async {
    try {
      return Result.success(data: await repo.getUpdate());
    } catch (e) {
      return Result.onError(message: 'Ha ocurrido un error: $e');
    }
  }
}