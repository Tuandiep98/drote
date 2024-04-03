// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SketchTypeAdapter extends TypeAdapter<SketchType> {
  @override
  final int typeId = 3;

  @override
  SketchType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SketchType.scribble;
      case 1:
        return SketchType.line;
      case 2:
        return SketchType.square;
      case 3:
        return SketchType.circle;
      case 4:
        return SketchType.polygon;
      default:
        return SketchType.scribble;
    }
  }

  @override
  void write(BinaryWriter writer, SketchType obj) {
    switch (obj) {
      case SketchType.scribble:
        writer.writeByte(0);
        break;
      case SketchType.line:
        writer.writeByte(1);
        break;
      case SketchType.square:
        writer.writeByte(2);
        break;
      case SketchType.circle:
        writer.writeByte(3);
        break;
      case SketchType.polygon:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SketchTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
