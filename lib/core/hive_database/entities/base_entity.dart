import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class BaseEntity {
  @HiveField(0)
  String id = '';

  BaseEntity(){
    if(id == ''){
      id = const Uuid().v4();
    }
  }
}
