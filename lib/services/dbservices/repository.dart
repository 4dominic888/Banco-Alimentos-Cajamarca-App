abstract class Repository<T>{
    final String table;

    Repository(this.table);

    Future add(T item);
    Future<T?> getById(int id);
    Future<Iterable<T>?> getAll();
    Future update(int id, T item);
    Future delete(int id);
}