import 'dart:math' as math;
import 'dart:ui';

import 'package:drote/core/hive_database/entities/sketch_entity/sketch_entity.dart';
import 'package:drote/core/utils/enum.dart';
import 'package:drote/core/view_models/interfaces/iboard_viewmodel.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:drote/main.dart';
import 'package:drote/screens/drawing_canvas/models/drawing_mode.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class DrawingCanvas extends StatefulWidget {
  final double height;
  final double width;
  final Color selectedColor;
  final double strokeSize;
  final Image? backgroundImage;
  final double eraserSize;
  final DrawingMode drawingMode;
  final AnimationController sideBarController;
  final SketchEntity? currentSketch;
  final List<SketchEntity> allSketches;
  final GlobalKey canvasGlobalKey;
  final int polygonSides;
  final bool filled;
  const DrawingCanvas({
    Key? key,
    required this.height,
    required this.width,
    required this.selectedColor,
    required this.strokeSize,
    required this.backgroundImage,
    required this.eraserSize,
    required this.drawingMode,
    required this.sideBarController,
    required this.currentSketch,
    required this.allSketches,
    required this.canvasGlobalKey,
    required this.polygonSides,
    required this.filled,
  }) : super(key: key);
  @override
  DrawingCanvasState createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas> {
  late IBoardViewModel _viewModel;

  @override
  void initState() {
    _viewModel = context.read<IBoardViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.precise,
      child: Stack(
        children: [
          buildAllSketches(context),
          buildCurrentPath(context),
        ],
      ),
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
      boardId: _viewModel.currentBoard?.id ?? const Uuid().v4(),
      createdTime: DateTime.now(),
      points: [offsetMap],
      size: widget.drawingMode == DrawingMode.eraser
          ? widget.eraserSize
          : widget.strokeSize,
      color: widget.drawingMode == DrawingMode.eraser
          ? kCanvasColor.hashCode
          : widget.selectedColor.hashCode,
      sides: widget.polygonSides,
      filled: widget.drawingMode == DrawingMode.line ||
              widget.drawingMode == DrawingMode.pencil ||
              widget.drawingMode == DrawingMode.eraser
          ? false
          : widget.filled,
      type: () {
        switch (widget.drawingMode) {
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
    final points = List<Offset>.from(widget.currentSketch?.points ?? [])
      ..add(offset);
    var offsetsMap = points
        .map((e) => <dynamic, dynamic>{
              'dx': offset.dx,
              'dy': offset.dy,
            })
        .toList();

    var sketch = SketchEntity(
      boardId: _viewModel.currentBoard?.id ?? const Uuid().v4(),
      createdTime: DateTime.now(),
      points: offsetsMap,
      size: widget.drawingMode == DrawingMode.eraser
          ? widget.eraserSize
          : widget.strokeSize,
      color: widget.drawingMode == DrawingMode.eraser
          ? kCanvasColor.hashCode
          : widget.selectedColor.hashCode,
      sides: widget.polygonSides,
      filled: widget.drawingMode == DrawingMode.line ||
              widget.drawingMode == DrawingMode.pencil ||
              widget.drawingMode == DrawingMode.eraser
          ? false
          : widget.filled,
      type: () {
        switch (widget.drawingMode) {
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

  void onPointerUp(PointerUpEvent details) {
    _viewModel.addSketchToAllSketches(widget.currentSketch!);

    var sketch = SketchEntity(
      boardId: _viewModel.currentBoard?.id ?? const Uuid().v4(),
      createdTime: DateTime.now(),
      points: [],
      size: widget.drawingMode == DrawingMode.eraser
          ? widget.eraserSize
          : widget.strokeSize,
      color: widget.drawingMode == DrawingMode.eraser
          ? kCanvasColor.hashCode
          : widget.selectedColor.hashCode,
      sides: widget.polygonSides,
      filled: widget.drawingMode == DrawingMode.line ||
              widget.drawingMode == DrawingMode.pencil ||
              widget.drawingMode == DrawingMode.eraser
          ? false
          : widget.filled,
      type: () {
        switch (widget.drawingMode) {
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

  Widget buildAllSketches(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Selector<IBoardViewModel, List<SketchEntity>>(
        selector: (_ , __) => _viewModel.allSketches,
        builder: (context, sketches, _) {
          return RepaintBoundary(
            key: widget.canvasGlobalKey,
            child: Container(
              height: widget.height,
              width: widget.width,
              color: kCanvasColor,
              child: CustomPaint(
                painter: SketchPainter(
                  sketches: sketches,
                  backgroundImage: widget.backgroundImage,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCurrentPath(BuildContext context) {
    return Listener(
      onPointerDown: (details) => onPointerDown(details, context),
      onPointerMove: (details) => onPointerMove(details, context),
      onPointerUp: onPointerUp,
      child: Selector0<SketchEntity?>(
        selector: (_) => _viewModel.currentSketch,
        builder: (context, sketch, child) {
          return RepaintBoundary(
            child: SizedBox(
              height: widget.height,
              width: widget.width,
              child: CustomPaint(
                painter: SketchPainter(
                  sketches: sketch == null ? [] : [sketch],
                ),
              ),
            ),
          );
        },
      ),
    );
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

    debugPrint('sketches length: ${sketches.length}');
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
        ..color = Color(sketch.color)
        ..strokeCap = StrokeCap.round;

      if (!sketch.filled) {
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = sketch.size;
      }

      // define first and last points for convenience
      Offset firstPoint = Offset(sketch.points.first['dx'], sketch.points.first['dy']);
      Offset lastPoint = Offset(sketch.points.last['dx'], sketch.points.last['dy']);

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
    return oldDelegate.sketches != sketches;
  }
}
