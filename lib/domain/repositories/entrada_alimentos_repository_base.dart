import 'package:bancalcaj_app/domain/models/entrada.dart';
import 'package:bancalcaj_app/domain/interfaces/repository.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';

typedef E = Entrada;

abstract class EntradaAlimentosRepositoryBase extends Repository<E> implements ICrudable<E>{
  final String dataset = 'entradas';
  EntradaAlimentosRepositoryBase({required super.db});

  @override Future<String> add(E entrada);
  @override Future<E?> getById(String id);
  @override Future<PaginateData<E>?> getAll({required int page, required int limit, String? search});
  @override Future<bool> update(String id, E entrada);
  @override Future<bool> delete(String id);
}