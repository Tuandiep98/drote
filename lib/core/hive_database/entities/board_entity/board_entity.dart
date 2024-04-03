import 'package:drote/core/hive_database/entities/base_entity.dart';
import 'package:hive/hive.dart';

part 'board_entity.g.dart';

@HiveType(typeId: 2)
class BoardEntity extends BaseEntity {
  @HiveField(1)
  String name;
  @HiveField(2)
  String code;
  @HiveField(3)
  String createdBy;
  @HiveField(4)
  DateTime createdTime;
  @HiveField(5)
  String backgroundImage;
  @HiveField(6)
  String backgroundColor;
  @HiveField(7)
  double width;
  @HiveField(8)
  double height;

  BoardEntity({
    String id = '',
    this.name = '',
    this.code = '',
    this.createdBy = '',
    required this.createdTime,
    this.backgroundImage = '',
    this.backgroundColor = '',
    this.width = 1000,
    this.height = 2000,
  });
}
