// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:drote/core/view_models/interfaces/iboard_viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart' as cuper;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:drote/main.dart';
import 'package:drote/screens/drawing_canvas/drawing_canvas.dart';
import 'package:drote/screens/drawing_canvas/models/drawing_mode.dart';
import 'package:drote/screens/drawing_canvas/models/sketch.dart';
import 'package:drote/screens/drawing_canvas/widgets/canvas_side_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

import 'drawing_canvas/widgets/color_palette.dart';
import 'drawing_canvas/widgets/pencil_widget.dart';
import 'drawing_canvas/widgets/raw_button.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({Key? key}) : super(key: key);
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  @override
  Widget build(BuildContext context) {
    final canvasGlobalKey = GlobalKey();

    final selectedColor = useState(Colors.black);
    final strokeSize = useState<double>(10);
    final eraserSize = useState<double>(30);
    final filled = useState<bool>(false);
    final polygonSides = useState<int>(3);
    final backgroundImage = useState<Image?>(null);

    ValueNotifier<Sketch?> currentSketch = useState(null);
    ValueNotifier<List<Sketch>> allSketches = useState([]);

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
      initialValue: 1,
    );

    final undoRedoStack = useState(
      UndoRedoStack(
        sketchesNotifier: allSketches,
        currentSketchNotifier: currentSketch,
      ),
    );

    Future<Uint8List?> getBytes() async {
      RenderRepaintBoundary boundary = canvasGlobalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      Image image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      return pngBytes;
    }

    return Scaffold(
      body: Consumer<IBoardViewModel>(builder: (_, viewmodel, ___) {
        return Stack(
          children: [
            Container(
              color: kCanvasColor,
              width: double.maxFinite,
              height: double.maxFinite,
              child: DrawingCanvas(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                drawingMode: viewmodel.drawingMode,
                selectedColor: selectedColor,
                strokeSize: strokeSize,
                eraserSize: eraserSize,
                sideBarController: animationController,
                currentSketch: currentSketch,
                allSketches: allSketches,
                canvasGlobalKey: canvasGlobalKey,
                filled: filled,
                polygonSides: polygonSides,
                backgroundImage: backgroundImage,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: IntrinsicWidth(
                  child: Container(
                    height: 45,
                    constraints: const BoxConstraints(
                      maxWidth: kIsWeb ? 550 : double.infinity,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 2),
                        Selector<IBoardViewModel, DrawingMode>(
                            selector: (_, vm) => vm.drawingMode,
                            builder: (_, drawingMode, ___) {
                              var icon = Icons.edit;
                              switch (drawingMode) {
                                case DrawingMode.line:
                                  icon = Icons.line_axis;
                                  break;
                                case DrawingMode.arrow:
                                  icon = Icons.arrow_back;
                                  break;
                                case DrawingMode.eraser:
                                  icon = FontAwesomeIcons.eraser;
                                  break;
                                case DrawingMode.polygon:
                                  icon = Icons.hexagon_outlined;
                                  break;
                                default:
                                  icon = Icons.edit;
                                  break;
                              }
                              return RawButton(
                                context: context,
                                icon: icon,
                                tooltip: 'Drawing mode',
                                onPressed: (currentContext) async {
                                  await showPopover(
                                    context: currentContext,
                                    barrierColor: Colors.transparent,
                                    bodyBuilder: (context) =>
                                        const PencilWidget(),
                                    onPop: () {},
                                    direction: PopoverDirection.bottom,
                                    width: 350,
                                    arrowHeight: 15,
                                    arrowWidth: 30,
                                  );
                                },
                              );
                            }),
                        RawButton(
                          context: context,
                          icon: cuper.CupertinoIcons.textformat_size,
                          tooltip: 'Size',
                          onPressed: (currentContext) async {
                            await showPopover(
                              context: currentContext,
                              barrierColor: Colors.transparent,
                              bodyBuilder: (context) => cuper.Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Stroke Size: ',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Slider(
                                          value: strokeSize.value,
                                          min: 0,
                                          max: 50,
                                          onChanged: (val) {
                                            strokeSize.value = val;
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Eraser Size: ',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Slider(
                                          value: eraserSize.value,
                                          min: 0,
                                          max: 80,
                                          onChanged: (val) {
                                            eraserSize.value = val;
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              onPop: () {},
                              direction: PopoverDirection.bottom,
                              width: 300,
                              arrowHeight: 15,
                              arrowWidth: 30,
                            );
                          },
                        ),
                        RawButton(
                          context: context,
                          icon: cuper.CupertinoIcons.arrow_turn_up_left,
                          tooltip: 'Undo',
                          onPressed: allSketches.value.isNotEmpty
                              ? (context) => undoRedoStack.value.undo()
                              : null,
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: undoRedoStack.value.canRedo,
                          builder: (_, canRedo, __) {
                            return RawButton(
                              context: context,
                              icon: cuper.CupertinoIcons.arrow_turn_up_right,
                              tooltip: 'Redo',
                              onPressed: canRedo
                                  ? (context) => undoRedoStack.value.redo()
                                  : null,
                            );
                          },
                        ),
                        RawButton(
                          context: context,
                          icon: cuper.CupertinoIcons.delete_simple,
                          tooltip: 'Clear',
                          onPressed: (context) => undoRedoStack.value.clear(),
                        ),
                        RawButton(
                          context: context,
                          icon: Icons.abc,
                          tooltip: 'Color',
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectedColor.value,
                              border: selectedColor.value == Colors.white
                                  ? Border.all(
                                      color: Colors.grey,
                                      width: 0.2,
                                    )
                                  : null,
                            ),
                          ),
                          onPressed: (currentContext) async {
                            await showPopover(
                              context: currentContext,
                              barrierColor: Colors.transparent,
                              bodyBuilder: (context) => cuper.Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ColorPalette(
                                  selectedColor: selectedColor,
                                ),
                              ),
                              onPop: () {},
                              direction: PopoverDirection.bottom,
                              width: 350,
                              arrowHeight: 15,
                              arrowWidth: 30,
                            );
                          },
                        ),
                        RawButton(
                          context: context,
                          icon: backgroundImage.value == null
                              ? cuper.CupertinoIcons.photo_on_rectangle
                              : cuper
                                  .CupertinoIcons.photo_fill_on_rectangle_fill,
                          tooltip: backgroundImage.value == null
                              ? 'Add background image'
                              : 'Remove background image',
                          onPressed: (context) async {
                            try {
                              if (backgroundImage.value != null) {
                                backgroundImage.value = null;
                              } else {
                                backgroundImage.value = await getImage;
                              }
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          },
                        ),
                        RawButton(
                          context: context,
                          icon: cuper.CupertinoIcons.arrow_down_doc,
                          tooltip: 'Export',
                          onPressed: (context) async {
                            await showPopover(
                              context: context,
                              barrierColor: Colors.transparent,
                              bodyBuilder: (context) => cuper.Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 140,
                                      child: TextButton(
                                        child: const Text('Export PNG'),
                                        onPressed: () async {
                                          Uint8List? pngBytes =
                                              await getBytes();
                                          if (pngBytes != null) {
                                            saveFile(pngBytes, 'png');
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 140,
                                      child: TextButton(
                                        child: const Text('Export JPEG'),
                                        onPressed: () async {
                                          Uint8List? pngBytes =
                                              await getBytes();
                                          if (pngBytes != null) {
                                            saveFile(pngBytes, 'jpeg');
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPop: () {},
                              direction: PopoverDirection.bottom,
                              width: 160,
                              arrowHeight: 15,
                              arrowWidth: 30,
                            );
                          },
                        ),
                        const SizedBox(width: 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _CustomAppBar(animationController: animationController),
          ],
        );
      }),
    );
  }

  void saveFile(Uint8List bytes, String extension) async {
    if (kIsWeb) {
      html.AnchorElement()
        ..href = '${Uri.dataFromBytes(bytes, mimeType: 'image/$extension')}'
        ..download =
            'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension'
        ..style.display = 'none'
        ..click();
    } else {
      await FileSaver.instance.saveFile(
        name: 'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension',
        bytes: bytes,
        ext: extension,
        mimeType: extension == 'png' ? MimeType.png : MimeType.jpeg,
      );
    }
  }

  Future<Image> get getImage async {
    final completer = Completer<Image>();
    if (!kIsWeb &&
        defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      final file = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (file != null) {
        final filePath = file.files.single.path;
        final bytes = filePath == null
            ? file.files.first.bytes
            : File(filePath).readAsBytesSync();
        if (bytes != null) {
          completer.complete(decodeImageFromList(bytes));
        } else {
          completer.completeError('No image selected');
        }
      }
    } else {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        completer.complete(
          decodeImageFromList(bytes),
        );
      } else {
        completer.completeError('No image selected');
      }
    }

    return completer.future;
  }
}

class _CustomAppBar extends StatelessWidget {
  final AnimationController animationController;

  const _CustomAppBar({Key? key, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                if (animationController.value == 0) {
                  animationController.forward();
                } else {
                  animationController.reverse();
                }
              },
              icon: const Icon(Icons.menu),
            ),
            const Text(
              'Drote',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}