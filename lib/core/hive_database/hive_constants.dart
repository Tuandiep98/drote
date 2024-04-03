import 'package:drote/core/hive_database/entities/board_entity/board_entity.dart';
import 'package:drote/core/hive_database/entities/sketch_entity/sketch_entity.dart';
import 'package:drote/core/utils/enum.dart';
import 'package:hive/hive.dart';

class HiveBoxName {
  static const String sketch = 'sketch'; // 1
  static const String board = 'board'; // 2
  static const String sketchType = 'sketchType'; // 3
}

class HiveBoxMap {
  static Map<Type, MyHive> hiveBoxMap = {
    SketchEntity: MyHive<SketchEntity>(
      HiveBoxName.sketch,
      () {
        Hive.registerAdapter(SketchEntityAdapter());
        Hive.registerAdapter(SketchTypeAdapter());
      },
    ),
    BoardEntity: MyHive<BoardEntity>(
      HiveBoxName.board,
      () {
        Hive.registerAdapter(BoardEntityAdapter());
      },
    ),
  };
}

class MyHive<EntityT> {
  String boxName;
  late Future<void> Function() openBoxFunction;
  void Function() registerAdapterFunction;

  MyHive(this.boxName, this.registerAdapterFunction) {
    openBoxFunction = () async {
      await Hive.openBox<EntityT>(boxName);
    };
  }
}
