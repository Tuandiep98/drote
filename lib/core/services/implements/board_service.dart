import 'package:drote/core/hive_database/daos/board_dao.dart';
import 'package:drote/core/hive_database/daos/sketch_dao.dart';
import 'package:drote/core/services/interfaces/iboard_service.dart';
import 'package:drote/global/locator.dart';

class BoardService implements IBoardService {
  final _sketchDao = locator<SketchDao>();
  final _boardDao = locator<BoardDao>();
}
