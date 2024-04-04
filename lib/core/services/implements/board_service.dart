import 'package:drote/core/hive_database/daos/board_dao.dart';
import 'package:drote/core/hive_database/daos/sketch_dao.dart';
import 'package:drote/core/hive_database/entities/board_entity/board_entity.dart';
import 'package:drote/core/hive_database/entities/sketch_entity/sketch_entity.dart';
import 'package:drote/core/services/interfaces/iboard_service.dart';
import 'package:drote/global/locator.dart';

class BoardService implements IBoardService {
  final _boardDao = locator<BoardDao>();
  final _sketchDao = locator<SketchDao>();

  @override
  List<BoardEntity> getAllBoards() {
    return _boardDao.getAll();
  }

  @override
  Future<void> createBoard(BoardEntity boardEntity) async {
    await _boardDao.insert(boardEntity);
  }

  @override
  List<SketchEntity> getAllSketches(String boardId) {
    return _sketchDao.getAll().where((x) => x.boardId == boardId).toList();
  }

  @override
  Future<void> insertSketchToBoard(
      SketchEntity sketchEntity, String boardId) async {
    sketchEntity.boardId = boardId;
    await _sketchDao.insert(sketchEntity);
  }

  @override
  Future<void> removeSketch(SketchEntity sketchEntity) async {
    await _sketchDao.delete(sketchEntity.id);
  }

  @override
  Future<void> clearSketchesOfBoard(String boardId) async {
    List<SketchEntity> sketches =
        _sketchDao.getAll().where((x) => x.boardId == boardId).toList();
    await _sketchDao.deleteAll(sketches.map((e) => e.id).toList());
  }

  @override
  Future<void> deleteBoard(String boardId) async {
    await _boardDao.delete(boardId);
  }
}
