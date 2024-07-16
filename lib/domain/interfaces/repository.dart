import 'package:bancalcaj_app/services/db_services/data_base_service.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';

abstract class Repository<T>{
  final DataBaseService db;
  Repository({required this.db});
}

abstract class IAddable<T> { Future add(T item); }
abstract class IUpdatable<T> { Future update(int id, T item); }
abstract class IDeletable<T> { Future delete(int id); }
abstract class IGetable<T> { Future<T?> getById(int id); Future<Iterable<T>> getAll(); }
abstract class IPaginatable<T> {
  Future<PaginateData<T>?> getAllPaginated({int? page = 1, int? limit = 5, String? search});  
}

abstract class ICrudable<T> implements IAddable<T>, IUpdatable<T>, IDeletable<T>, IGetable<T> { }