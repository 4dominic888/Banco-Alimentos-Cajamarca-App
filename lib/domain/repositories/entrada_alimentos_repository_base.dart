import 'package:bancalcaj_app/domain/models/entrada.dart';
import 'package:bancalcaj_app/domain/interfaces/repository.dart';
import 'package:bancalcaj_app/domain/classes/paginate_data.dart';

typedef E = Entrada;
typedef EV = EntradaView;

abstract class EntradaAlimentosRepositoryBase extends Repository<E> implements ICrudable<E, EV>{
  final String dataset = 'entradas';
  EntradaAlimentosRepositoryBase({required super.db});

  @override Future<String> add(E entrada);
  @override Future<E?> getById(String id);
  @override Future<PaginateData<EV>?> getAll({required int page, required int limit, Map<String, dynamic>? aditionalQueries});
  @override Future<bool> update(String id, E entrada);
  @override Future<bool> delete(String id);
}