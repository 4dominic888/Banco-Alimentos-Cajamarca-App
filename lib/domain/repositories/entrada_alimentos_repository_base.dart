import 'package:bancalcaj_app/domain/models/entrada.dart';
import 'package:bancalcaj_app/domain/interfaces/repository.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';

typedef E = Entrada;

abstract class EntradaAlimentosRepositoryBase extends Repository<E> implements ICrudable<E>, IPaginatable<E>{
  final String dataset = 'entradas';
  EntradaAlimentosRepositoryBase({required super.db});

  @override Future add(E entrada);
  @override Future<Iterable<E>> getAll();
  @override Future<E?> getById(int id);
  @override Future<PaginateData<E>?> getAllPaginated({int? page = 1, int? limit = 5, String? search});
  @override Future update(int id, E entrada);
  @override Future delete(int id);
}