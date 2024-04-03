import 'package:drote/core/hive_database/daos/board_dao.dart';
import 'package:drote/core/hive_database/entities/board_entity/board_entity.dart';
import 'package:drote/core/services/interfaces/iboard_service.dart';
import 'package:drote/global/locator.dart';

class BoardService implements IBoardService {
  final _boardDao = locator<BoardDao>();

  @override
  List<BoardEntity> getAllBoards() {
    return _boardDao.getAll();
  }

  @override
  Future<void> createBoard(BoardEntity boardEntity) async {
    await _boardDao.insert(boardEntity);
  }
}
