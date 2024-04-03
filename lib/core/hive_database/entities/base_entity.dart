import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class BaseEntity {
  @HiveField(0)
  String id = const Uuid().v4();

  BaseEntity(){
    id = const Uuid().v4();
  }
}
