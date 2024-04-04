import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class BaseEntity {
  @HiveField(0)
  String id = '';

  BaseEntity({required this.id}){
    if(id == ''){
      id = const Uuid().v4();
    }
  }
}
