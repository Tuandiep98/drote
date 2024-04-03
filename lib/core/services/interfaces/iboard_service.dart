import 'package:drote/core/hive_database/entities/board_entity/board_entity.dart';

abstract class IBoardService {
  List<BoardEntity> getAllBoards();
  Future<void> createBoard(BoardEntity boardEntity);
}
