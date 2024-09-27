import 'package:bancalcaj_app/domain/models/update_data.dart';

typedef E = UpdateData;

abstract class UpdaterRepositoryBase {
  UpdaterRepositoryBase();

  Future<E> getUpdate();
}