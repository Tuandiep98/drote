import 'dart:ui';

import 'package:drote/core/hive_database/entities/board_entity/board_entity.dart';
import 'package:drote/core/hive_database/entities/sketch_entity/sketch_entity.dart';
import 'package:drote/screens/drawing_canvas/models/drawing_mode.dart';
import 'package:flutter/material.dart' hide Image;

abstract class IBoardViewModel extends ChangeNotifier {
  Color get selectedColor;
  double get strokeSize;
  double get eraserSize;
  DrawingMode get drawingMode;
  bool get filled;
  int get polygonSides;
  Image? get backgroundImage;
  SketchEntity? get currentSketch;
  List<SketchEntity> get allSketches;
  BoardEntity? get currentBoard;
  List<BoardEntity> get allBoards;
  bool get canRedo;

  void setBackgroundImage(Image? image);
  void setCurrentSketch(SketchEntity sketchEntity);
  void setDrawingMode(DrawingMode drawingMode);
  void setEraserSize(double size);
  void setFilled(bool value);
  void setPolygonSides(int value);
  void setSelectedColor(Color value);
  void setStrokeSize(double value);
  void setCurrentBoard(BoardEntity boardEntity);
  void addSketchToAllSketches(SketchEntity currentSketch);

  void undo();
  void redo();
  void clear();

  Future<void> init();
  Future<void> insertSketchToBoard(SketchEntity sketchEntity, String boardId);
  Future<void> createNewBoard();
  Future<void> deleteBoard(BoardEntity boardEntity);
}
