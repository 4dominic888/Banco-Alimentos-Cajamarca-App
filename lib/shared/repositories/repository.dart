import 'package:bancalcaj_app/shared/util/paginate_data.dart';

abstract class Repository<T>{
  final String table;

  Repository(this.table);

  Future add(T item);
  Future<T?> getById(int id);
  Future<Iterable<T>> getAll();
  Future<PaginateData<T>?> getAllPaginated({int? page = 1, int? limit = 5, String? search});
  Future update(int id, T item);
  Future delete(int id);
}