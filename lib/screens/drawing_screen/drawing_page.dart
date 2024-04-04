// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:drote/core/view_models/interfaces/iboard_viewmodel.dart';
import 'package:drote/screens/drawing_canvas/widgets/stroke_size.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart' as cuper;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:drote/main.dart';
import 'package:drote/screens/drawing_canvas/drawing_canvas.dart';
import 'package:drote/screens/drawing_canvas/models/drawing_mode.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

import '../drawing_canvas/widgets/color_palette.dart';
import '../drawing_canvas/widgets/pencil_widget.dart';
import '../drawing_canvas/widgets/raw_button.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({Key? key}) : super(key: key);
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final canvasGlobalKey = GlobalKey();

    final animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      value: 1,
      vsync: this,
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
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: const BoxDecoration(
                color: kCanvasColor,
                image: DecorationImage(
                  image: AssetImage("assets/images/G788_large.jpg"),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
              child: DrawingCanvas(
                width: viewmodel.currentBoard?.width ??
                    MediaQuery.of(context).size.width,
                height: viewmodel.currentBoard?.height ??
                    MediaQuery.of(context).size.height,
                sideBarController: animationController,
                canvasGlobalKey: canvasGlobalKey,
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 2),
                          Selector<IBoardViewModel, DrawingMode>(
                              selector: (_, vm) => vm.drawingMode,
                              builder: (_, drawingMode, ___) {
                                var icon = Icons.edit;
                                switch (drawingMode) {
                                  case DrawingMode.pencil:
                                    icon = Icons.edit;
                                    break;
                                  case DrawingMode.line:
                                    icon = FontAwesomeIcons.minus;
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
                                  case DrawingMode.square:
                                    icon = Icons.crop_square_rounded;
                                    break;
                                  case DrawingMode.circle:
                                    icon = FontAwesomeIcons.circle;
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
                                bodyBuilder: (context) =>
                                    const StrokeSizeWidget(),
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
                            onPressed: viewmodel.allSketches.isNotEmpty
                                ? (context) => viewmodel.undo()
                                : null,
                          ),
                          RawButton(
                            context: context,
                            icon: cuper.CupertinoIcons.arrow_turn_up_right,
                            tooltip: 'Redo',
                            onPressed: viewmodel.canRedo
                                ? (context) => viewmodel.redo()
                                : null,
                          ),
                          RawButton(
                            context: context,
                            icon: cuper.CupertinoIcons.delete_simple,
                            tooltip: 'Clear',
                            onPressed: (context) => viewmodel.clear(),
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
                                color: viewmodel.selectedColor,
                                border: viewmodel.selectedColor == Colors.white
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
                                  padding: const EdgeInsets.all(15),
                                  child: ColorPalette(
                                    selectedColor: viewmodel.selectedColor,
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
                            icon: viewmodel.backgroundImage == null
                                ? cuper.CupertinoIcons.photo_on_rectangle
                                : cuper.CupertinoIcons
                                    .photo_fill_on_rectangle_fill,
                            tooltip: viewmodel.backgroundImage == null
                                ? 'Add background image'
                                : 'Remove background image',
                            onPressed: (context) async {
                              try {
                                if (viewmodel.backgroundImage != null) {
                                  viewmodel.setBackgroundImage(null);
                                } else {
                                  viewmodel.setBackgroundImage(await getImage);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                          RawButton(
                            context: context,
                            icon: cuper.CupertinoIcons.collections,
                            tooltip: 'Close board',
                            onPressed: (context) => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 2),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
