// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardEntityAdapter extends TypeAdapter<BoardEntity> {
  @override
  final int typeId = 2;

  @override
  BoardEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoardEntity(
      id: fields[0] as String,
      name: fields[1] as String,
      code: fields[2] as String,
      createdBy: fields[3] as String,
      createdTime: fields[4] as DateTime,
      backgroundImage: fields[5] as String,
      backgroundColor: fields[6] as String,
      width: fields[7] as double,
      height: fields[8] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BoardEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.createdTime)
      ..writeByte(5)
      ..write(obj.backgroundImage)
      ..writeByte(6)
      ..write(obj.backgroundColor)
      ..writeByte(7)
      ..write(obj.width)
      ..writeByte(8)
      ..write(obj.height)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
