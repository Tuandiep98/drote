import 'dart:math' as math;
import 'dart:ui';

import 'package:drote/core/hive_database/entities/sketch_entity/sketch_entity.dart';
import 'package:drote/core/utils/enum.dart';
import 'package:drote/core/utils/hex_color_extension.dart';
import 'package:drote/core/view_models/interfaces/iboard_viewmodel.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:drote/main.dart';
import 'package:drote/screens/drawing_canvas/models/drawing_mode.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zoom_widget/zoom_widget.dart';

class DrawingCanvas extends StatefulWidget {
  final double height;
  final double width;
  final AnimationController sideBarController;
  final GlobalKey canvasGlobalKey;
  const DrawingCanvas({
    Key? key,
    required this.height,
    required this.width,
    required this.sideBarController,
    required this.canvasGlobalKey,
  }) : super(key: key);
  @override
  DrawingCanvasState createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas> {
  late IBoardViewModel _viewModel;
  bool isSketching = true;

  @override
  void initState() {
    _viewModel = context.read<IBoardViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IBoardViewModel>(
      builder: (_, viewmodel, __) {
        return Zoom(
          enableScroll: false,
          initTotalZoomOut: true,
          onPositionUpdate: (offset) {},
          onScaleUpdate: (p0, p1) {
            setState(() {
              isSketching = p1.round() == 1;
            });
          },
          child: MouseRegion(
            cursor: isSketching
                ? SystemMouseCursors.precise
                : SystemMouseCursors.grab,
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: RepaintBoundary(
                    key: widget.canvasGlobalKey,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: kCanvasColor,
                      child: CustomPaint(
                        painter: SketchPainter(
                          sketches: viewmodel.allSketches,
                          backgroundImage: viewmodel.backgroundImage,
                        ),
                      ),
                    ),
                  ),
                ),
                Listener(
                  onPointerDown: isSketching
                      ? (details) => onPointerDown(details, context)
                      : (details) {},
                  onPointerMove: isSketching
                      ? (details) => onPointerMove(details, context)
                      : (details) {},
                  onPointerUp: isSketching ? onPointerUp : (event) {},
                  child: RepaintBoundary(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: CustomPaint(
                        painter: SketchPainter(
                          sketches: viewmodel.currentSketch == null
                              ? []
                              : [viewmodel.currentSketch!],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onPointerDown(PointerDownEvent details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    var offsetMap = <dynamic, dynamic>{
      'dx': offset.dx,
      'dy': offset.dy,
    };
    var sketch = SketchEntity(
      id: const Uuid().v4(),
      boardId: _viewModel.currentBoard?.id ?? const Uuid().v4(),
      createdTime: DateTime.now(),
      points: [offsetMap],
      size: _viewModel.drawingMode == DrawingMode.eraser
          ? _viewModel.eraserSize
          : _viewModel.strokeSize,
      color: _viewModel.drawingMode == DrawingMode.eraser
          ? kCanvasColor.toHex()
          : _viewModel.selectedColor.toHex(),
      sides: _viewModel.polygonSides,
      filled: _viewModel.drawingMode == DrawingMode.line ||
              _viewModel.drawingMode == DrawingMode.pencil ||
              _viewModel.drawingMode == DrawingMode.eraser
          ? false
          : _viewModel.filled,
      type: () {
        switch (_viewModel.drawingMode) {
          case DrawingMode.eraser:
          case DrawingMode.pencil:
            return SketchType.scribble;
          case DrawingMode.line:
            return SketchType.line;
          case DrawingMode.square:
            return SketchType.square;
          case DrawingMode.circle:
            return SketchType.circle;
          case DrawingMode.polygon:
            return SketchType.polygon;
          default:
            return SketchType.scribble;
        }
      }(),
    );
    _viewModel.setCurrentSketch(sketch);
  }

  void onPointerMove(PointerMoveEvent details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    List<Map<dynamic, dynamic>> points = [
      ..._viewModel.currentSketch?.points ?? [],
      <dynamic, dynamic>{
        'dx': offset.dx,
        'dy': offset.dy,
      }
    ];
    if (_viewModel.currentSketch != null) {
      var sketch = _viewModel.currentSketch!..points = points;
      _viewModel.setCurrentSketch(sketch);
    }
  }

  Future<void> onPointerUp(PointerUpEvent details) async {
    if (_viewModel.currentSketch != null && _viewModel.currentBoard != null) {
      await _viewModel.insertSketchToBoard(
          _viewModel.currentSketch!, _viewModel.currentBoard!.id);
    }

    _viewModel.addSketchToAllSketches(_viewModel.currentSketch!);

    var sketch = SketchEntity(
      id: const Uuid().v4(),
      boardId: _viewModel.currentBoard?.id ?? const Uuid().v4(),
      createdTime: DateTime.now(),
      points: [],
      size: _viewModel.drawingMode == DrawingMode.eraser
          ? _viewModel.eraserSize
          : _viewModel.strokeSize,
      color: _viewModel.drawingMode == DrawingMode.eraser
          ? kCanvasColor.toHex()
          : _viewModel.selectedColor.toHex(),
      sides: _viewModel.polygonSides,
      filled: _viewModel.drawingMode == DrawingMode.line ||
              _viewModel.drawingMode == DrawingMode.pencil ||
              _viewModel.drawingMode == DrawingMode.eraser
          ? false
          : _viewModel.filled,
      type: () {
        switch (_viewModel.drawingMode) {
          case DrawingMode.eraser:
          case DrawingMode.pencil:
            return SketchType.scribble;
          case DrawingMode.line:
            return SketchType.line;
          case DrawingMode.square:
            return SketchType.square;
          case DrawingMode.circle:
            return SketchType.circle;
          case DrawingMode.polygon:
            return SketchType.polygon;
          default:
            return SketchType.scribble;
        }
      }(),
    );
    _viewModel.setCurrentSketch(sketch);
  }
}

class SketchPainter extends CustomPainter {
  final List<SketchEntity> sketches;
  final Image? backgroundImage;

  const SketchPainter({
    Key? key,
    this.backgroundImage,
    required this.sketches,
  });

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('start paint');
    if (backgroundImage != null) {
      canvas.drawImageRect(
        backgroundImage!,
        Rect.fromLTWH(
          0,
          0,
          backgroundImage!.width.toDouble(),
          backgroundImage!.height.toDouble(),
        ),
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint(),
      );
    }

    for (SketchEntity sketch in sketches) {
      final points = sketch.points;
      if (points.isEmpty) return;

      final path = Path();
      path.moveTo(points[0]['dx'], points[0]['dy']);
      if (points.length < 2) {
        // If the path only has one line, draw a dot.
        path.addOval(
          Rect.fromCircle(
            center: Offset(points[0]['dx'], points[0]['dy']),
            radius: 1,
          ),
        );
      }

      for (int i = 1; i < points.length - 1; ++i) {
        final p0 = points[i];
        final p1 = points[i + 1];
        path.quadraticBezierTo(
          p0['dx'],
          p0['dy'],
          (p0['dx'] + p1['dx']) / 2,
          (p0['dy'] + p1['dy']) / 2,
        );
      }

      Paint paint = Paint()
        ..color = colorFromHex(sketch.color) ?? Colors.black
        ..strokeCap = StrokeCap.round;

      if (!sketch.filled) {
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = sketch.size;
      }

      // define first and last points for convenience
      Offset firstPoint =
          Offset(sketch.points.first['dx'], sketch.points.first['dy']);
      Offset lastPoint =
          Offset(sketch.points.last['dx'], sketch.points.last['dy']);

      // create rect to use rectangle and circle
      Rect rect = Rect.fromPoints(firstPoint, lastPoint);

      // Calculate center point from the first and last points
      Offset centerPoint = (firstPoint / 2) + (lastPoint / 2);

      // Calculate path's radius from the first and last points
      double radius = (firstPoint - lastPoint).distance / 2;

      if (sketch.type == SketchType.scribble) {
        canvas.drawPath(path, paint);
      } else if (sketch.type == SketchType.square) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(5)),
          paint,
        );
      } else if (sketch.type == SketchType.line) {
        canvas.drawLine(firstPoint, lastPoint, paint);
      } else if (sketch.type == SketchType.circle) {
        canvas.drawOval(rect, paint);
        // Uncomment this line if you need a PERFECT CIRCLE
        // canvas.drawCircle(centerPoint, radius , paint);
      } else if (sketch.type == SketchType.polygon) {
        Path polygonPath = Path();
        int sides = sketch.sides;
        var angle = (math.pi * 2) / sides;

        double radian = 0.0;

        Offset startPoint =
            Offset(radius * math.cos(radian), radius * math.sin(radian));

        polygonPath.moveTo(
          startPoint.dx + centerPoint.dx,
          startPoint.dy + centerPoint.dy,
        );
        for (int i = 1; i <= sides; i++) {
          double x = radius * math.cos(radian + angle * i) + centerPoint.dx;
          double y = radius * math.sin(radian + angle * i) + centerPoint.dy;
          polygonPath.lineTo(x, y);
        }
        polygonPath.close();
        canvas.drawPath(polygonPath, paint);
      }
    }
    debugPrint('sketches length: ${sketches.length}');
  }

  @override
  bool shouldRepaint(covariant SketchPainter oldDelegate) {
    // return oldDelegate.sketches.length != sketches.length;
    return true;
  }
}
