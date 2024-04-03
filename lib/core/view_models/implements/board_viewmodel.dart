// ignore_for_file: prefer_final_fields

import 'package:drote/core/hive_database/entities/board_entity/board_entity.dart';
import 'package:drote/core/hive_database/entities/sketch_entity/sketch_entity.dart';
import 'package:drote/core/view_models/interfaces/iboard_viewmodel.dart';
import 'package:drote/screens/drawing_canvas/models/drawing_mode.dart';
import 'package:flutter/material.dart';

class BoardViewModel extends ChangeNotifier implements IBoardViewModel {
  List<SketchEntity> _allSketches = [];
  @override
  List<SketchEntity> get allSketches => _allSketches;

  Image? _backgroundImage;
  @override
  Image? get backgroundImage => _backgroundImage;
  @override
  void setBackgroundImage(Image image) {
    _backgroundImage = image;
    notifyListeners();
  }

  SketchEntity? _currentSketch;
  @override
  SketchEntity? get currentSketch => _currentSketch;
  @override
  void setCurrentSketch(SketchEntity sketchEntity) {
    _currentSketch = sketchEntity;
    notifyListeners();
  }

  DrawingMode _drawingMode = DrawingMode.pencil;
  @override
  DrawingMode get drawingMode => _drawingMode;
  @override
  void setDrawingMode(DrawingMode drawingMode) {
    _drawingMode = drawingMode;
    notifyListeners();
  }

  double _eraserSize = 30;
  @override
  double get eraserSize => _eraserSize;
  @override
  void setEraserSize(double size) {
    _eraserSize = size;
    notifyListeners();
  }

  bool _filled = false;
  @override
  bool get filled => _filled;
  @override
  void setFilled(bool value) {
    if (_filled == value) return;
    _filled = value;
    notifyListeners();
  }

  int _polygonSides = 3;
  @override
  int get polygonSides => _polygonSides;
  @override
  void setPolygonSides(int value) {
    if (_polygonSides == value) return;
    _polygonSides = value;
    notifyListeners();
  }

  Color _selectedColor = Colors.black;
  @override
  Color get selectedColor => _selectedColor;
  @override
  void setSelectedColor(Color value) {
    if (_selectedColor == value) return;
    _selectedColor = value;
    notifyListeners();
  }

  double _strokeSize = 10;
  @override
  double get strokeSize => _strokeSize;
  @override
  void setStrokeSize(double value) {
    if (_strokeSize == value) return;
    _strokeSize = value;
    notifyListeners();
  }

  BoardEntity? _currentBoard;
  @override
  BoardEntity? get currentBoard => _currentBoard;

  @override
  void addSketchToAllSketches(SketchEntity currentSketch) {
    _allSketches = [..._allSketches, currentSketch];
    notifyListeners();
  }

  @override
  void setCurrentBoard(BoardEntity boardEntity) {
    _currentBoard = boardEntity;
    notifyListeners();
  }
}
