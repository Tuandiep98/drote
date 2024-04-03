import 'package:hive/hive.dart';

part 'enum.g.dart';

@HiveType(typeId: 3)
enum SketchType {
  @HiveField(0)
  scribble,
  @HiveField(1)
  line,
  @HiveField(2)
  square,
  @HiveField(3)
  circle,
  @HiveField(4)
  polygon,
}
