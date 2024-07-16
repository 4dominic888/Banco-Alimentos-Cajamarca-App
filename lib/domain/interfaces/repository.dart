import 'package:bancalcaj_app/domain/interfaces/database_interface.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';

abstract class Repository<T>{
  final DatabaseInterface db;
  Repository({required this.db});
}

abstract class IAddable<T> { Future add(T item); }
abstract class IUpdatable<T> { Future update(String id, T item); }
abstract class IDeletable<T> { Future delete(String id); }
abstract class IGetable<T> { 
  Future<T?> getById(String id);
  Future<PaginateData<T>?> getAll({required int page, required int limit, required String search});
}

abstract class ICrudable<T> implements IAddable<T>, IUpdatable<T>, IDeletable<T>, IGetable<T> { }