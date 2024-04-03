import 'package:drote/core/services/implements/board_service.dart';
import 'package:drote/core/services/interfaces/iboard_service.dart';
import 'package:get_it/get_it.dart';

void registerServiceSingletons(GetIt locator) {
  locator.registerLazySingleton<IBoardService>(() => BoardService());
}
