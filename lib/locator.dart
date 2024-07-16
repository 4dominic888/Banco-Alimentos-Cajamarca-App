import 'package:bancalcaj_app/data/mongodb/mongodb_mapper.dart';
import 'package:bancalcaj_app/domain/interfaces/database_interface.dart';
import 'package:bancalcaj_app/domain/services/entrada_alimentos_service_base.dart';
import 'package:bancalcaj_app/domain/services/proveedor_service_base.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/implementations/entrada_alimentos_repository_implement.dart';
import 'package:bancalcaj_app/presentation/entrada_alimentos/implementations/entrada_alimentos_service_implement.dart';
import 'package:bancalcaj_app/presentation/proveedores/implementations/proveedor_repository_implement.dart';
import 'package:bancalcaj_app/presentation/proveedores/implementations/proveedor_service_implement.dart';
import 'package:get_it/get_it.dart';

final GetIt _locator = GetIt.instance;

Future<void> setupLocator() async {

  //* Realmente no es mongoDB, solo es la conexion del backend a modo de intermediario
  //? Quizas se le cambie el nombre en un futuro
  final dbContext = DatabaseInterface.getInstance(MongoDBMapper());
  await dbContext.init();

  _locator.registerLazySingleton<EntradaAlimentosServiceBase>(
    () => EntradaAlimentosServiceImplement(
      EntradaAlimentosRepositoryImplement(db: dbContext)
    )
  );

  _locator.registerLazySingleton<ProveedorServiceBase>(
    () => ProveedorServiceImplement(
      ProveedorRepositoryImplement(db: dbContext)  
    )
  );
}