import 'package:drote/core/view_models/interfaces/iboard_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ColorPalette extends StatelessWidget {
  final Color selectedColor;

  const ColorPalette({
    Key? key,
    required this.selectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = kIsWeb ? 40 : 35;
    List<Color> colors = [
      Colors.black,
      Colors.white,
      ...Colors.primaries,
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Consumer<IBoardViewModel>(builder: (_, viewmodel, __) {
          return Wrap(
            alignment: WrapAlignment.center,
            spacing: kIsWeb ? 5 : 3,
            runSpacing: kIsWeb ? 5 : 3,
            children: [
              for (Color color in colors)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => viewmodel.setSelectedColor(color),
                    child: Container(
                      height: size,
                      width: size,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(
                          color: selectedColor == color
                              ? Colors.green
                              : Colors.grey,
                          width: 0.1,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    showColorWheel(context, selectedColor);
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/color_wheel.svg',
                    height: size,
                    width: size,
                  ),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 5),
      ],
    );
  }

  void showColorWheel(BuildContext context, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: color,
              onColorChanged: (value) {
                context.read<IBoardViewModel>().setSelectedColor(value);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
