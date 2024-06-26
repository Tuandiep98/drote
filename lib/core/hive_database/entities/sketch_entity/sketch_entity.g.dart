// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sketch_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SketchEntityAdapter extends TypeAdapter<SketchEntity> {
  @override
  final int typeId = 1;

  @override
  SketchEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SketchEntity(
      id: fields[0] as String,
      boardId: fields[1] as String,
      createdTime: fields[2] as DateTime,
      createdBy: fields[3] as String,
      points: (fields[4] as List)
          .map((dynamic e) => (e as Map).cast<dynamic, dynamic>())
          .toList(),
      color: fields[5] as String,
      size: fields[6] as double,
      type: fields[7] as SketchType,
      filled: fields[8] as bool,
      sides: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SketchEntity obj) {
    writer
      ..writeByte(10)
      ..writeByte(1)
      ..write(obj.boardId)
      ..writeByte(2)
      ..write(obj.createdTime)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.points)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.size)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.filled)
      ..writeByte(9)
      ..write(obj.sides)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SketchEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
