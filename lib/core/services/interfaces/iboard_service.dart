import 'package:drote/core/hive_database/entities/board_entity/board_entity.dart';
import 'package:drote/core/hive_database/entities/sketch_entity/sketch_entity.dart';

abstract class IBoardService {
  List<BoardEntity> getAllBoards();
  Future<void> createBoard(BoardEntity boardEntity);
  List<SketchEntity> getAllSketches(String boardId);
  Future<void> insertSketchToBoard(SketchEntity sketchEntity, String boardId);
  Future<void> removeSketch(SketchEntity sketchEntity);
  Future<void> clearSketchesOfBoard(String boardId);
}
