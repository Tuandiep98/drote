import 'package:drote/core/hive_database/hive_database.dart';
import 'package:drote/global/locator_dao.dart';
import 'package:drote/global/locator_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => HiveDatabase());
    await locator<HiveDatabase>().init();
    registerDaoSingletons(locator);
    registerServiceSingletons(locator);
}
