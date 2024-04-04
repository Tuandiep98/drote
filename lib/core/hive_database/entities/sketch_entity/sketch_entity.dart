import 'package:drote/core/hive_database/entities/base_entity.dart';
import 'package:drote/core/utils/enum.dart';
import 'package:hive/hive.dart';

part 'sketch_entity.g.dart';

@HiveType(typeId: 1)
class SketchEntity extends BaseEntity {
  @HiveField(1)
  String boardId;
  @HiveField(2)
  DateTime createdTime;
  @HiveField(3)
  String createdBy;
  @HiveField(4)
  List<Map> points; // offset dx, dy
  @HiveField(5)
  String color; // hex color
  @HiveField(6)
  double size;
  @HiveField(7)
  SketchType type;
  @HiveField(8)
  bool filled;
  @HiveField(9)
  int sides;

  SketchEntity({
    required String id,
    required this.boardId,
    required this.createdTime,
    this.createdBy = '',
    this.points = const [],
    this.color = '#000000',
    this.size = 1,
    this.type = SketchType.scribble,
    this.filled = false,
    this.sides = 0,
  }) : super(id: id);
}
