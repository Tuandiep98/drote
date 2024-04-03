// ignore_for_file: prefer_final_fields

import 'dart:ui';

import 'package:drote/core/hive_database/entities/board_entity/board_entity.dart';
import 'package:drote/core/hive_database/entities/sketch_entity/sketch_entity.dart';
import 'package:drote/core/services/interfaces/iboard_service.dart';
import 'package:drote/core/view_models/interfaces/iboard_viewmodel.dart';
import 'package:drote/global/locator.dart';
import 'package:drote/screens/drawing_canvas/models/drawing_mode.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:uuid/uuid.dart';

class BoardViewModel extends ChangeNotifier implements IBoardViewModel {
  final _boardService = locator<IBoardService>();

  List<SketchEntity> _redoStack = [];

  bool _canRedo = false;
  @override
  bool get canRedo => _canRedo;

  List<SketchEntity> _allSketches = [];
  @override
  List<SketchEntity> get allSketches => _allSketches;

  List<BoardEntity> _allBoards = [];
  @override
  List<BoardEntity> get allBoards => _allBoards;

  Image? _backgroundImage;
  @override
  Image? get backgroundImage => _backgroundImage;
  @override
  void setBackgroundImage(Image? image) {
    _backgroundImage = image;
    notifyListeners();
  }

  SketchEntity? _currentSketch;
  @override
  SketchEntity? get currentSketch => _currentSketch;
  @override
  void setCurrentSketch(SketchEntity sketchEntity) {
    _currentSketch = sketchEntity;
    _redoStack.clear();
    _canRedo = false;
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
    _allSketches = _boardService.getAllSketches(boardEntity.id);
    notifyListeners();
  }

  @override
  Future<void> undo() async {
    if (_allSketches.isNotEmpty) {
      var sketch = _allSketches.removeLast();
      await _boardService.removeSketch(sketch);
      _redoStack.add(sketch);
      _canRedo = true;
      _currentSketch = null;
      notifyListeners();
    }
  }

  @override
  Future<void> redo() async {
    if (_redoStack.isEmpty) return;
    final sketch = _redoStack.removeLast();
    _canRedo = _redoStack.isNotEmpty;
    await _boardService.insertSketchToBoard(sketch, _currentBoard!.id);
    _allSketches = [..._allSketches, sketch];
    notifyListeners();
  }

  @override
  Future<void> clear() async {
    _allSketches = [];
    _canRedo = false;
    _currentSketch = null;
    await _boardService.clearSketchesOfBoard(_currentBoard!.id);
    notifyListeners();
  }

  @override
  Future<void> init() async {
    _allBoards.clear();
    _allBoards = _boardService.getAllBoards();

    if (_allBoards.isEmpty) {
      var newBoard = BoardEntity(
        id: const Uuid().v4(),
        name: 'New Board',
        createdTime: DateTime.now(),
      );
      await _boardService.createBoard(newBoard);
      _currentBoard = newBoard;
    }
    notifyListeners();
  }

  @override
  Future<void> insertSketchToBoard(
      SketchEntity sketchEntity, String boardId) async {
    await _boardService.insertSketchToBoard(sketchEntity, boardId);
  }
}
