import 'package:bancalcaj_app/domain/classes/result.dart';
import 'package:bancalcaj_app/domain/models/update_data.dart';

abstract class UpdaterServiceBase {
  Future<Result<UpdateData>> obtenerActualizacion();
}