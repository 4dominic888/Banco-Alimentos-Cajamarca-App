import 'package:bancalcaj_app/domain/interfaces/database_interface.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';

abstract class Repository<T>{
  final DatabaseInterface db;
  Repository({required this.db});
}

/// Letra C del CRUD
abstract class IAddable<T> { Future add(T item); }

/// Letra R del CRUD
/// 
/// 
/// T es el tipo de dato a devolver en `getById`
/// 
/// U es el tipo de dato a devolver en `getAll`, por lo general debe ser una version corta y general del modelo
abstract class IGetable<T, U> { 
  Future<T?> getById(String id);
  Future<PaginateData<U>?> getAll({required int page, required int limit, Map<String, dynamic>? aditionalQueries});
}

/// Letra U del CRUD
abstract class IUpdatable<T> { Future update(String id, T item); }

/// Letra D del CRUD
abstract class IDeletable<T> { Future delete(String id); }


/// Abstraccion del CRUD, implementa todos los metodos de este
/// 
/// 
/// T es el tipo de dato a devolver en `getById`
/// 
/// U es el tipo de dato a devolver en `getAll`, por lo general debe ser una version corta y general del modelo
abstract class ICrudable<T, U> implements IAddable<T>, IUpdatable<T>, IDeletable<T>, IGetable<T, U> { }
