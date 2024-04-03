import 'package:drote/core/hive_database/daos/board_dao.dart';
import 'package:drote/core/hive_database/daos/sketch_dao.dart';
import 'package:get_it/get_it.dart';

void registerDaoSingletons(GetIt locator) {
  locator.registerLazySingleton(() => SketchDao());
  locator.registerLazySingleton(() => BoardDao());
}
