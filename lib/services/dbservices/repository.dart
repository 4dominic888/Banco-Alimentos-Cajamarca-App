abstract class Repository<T>{
    Future add(T item);
    Future<T?> getById(int id);
    Future<List<T>>? getAll();
    Future update(int id, T item);
    Future delete(int id);
}