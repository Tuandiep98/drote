import 'package:drote/core/view_models/interfaces/iboard_viewmodel.dart';
import 'package:drote/screens/drawing_canvas/models/drawing_mode.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'icon_box.dart';

class PencilWidget extends StatelessWidget {
  const PencilWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IBoardViewModel>(builder: (_, viewModel, __) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 5,
              runSpacing: 5,
              children: [
                IconBox(
                  iconData: FontAwesomeIcons.pencil,
                  selected: viewModel.drawingMode == DrawingMode.pencil,
                  onTap: () => viewModel.setDrawingMode(DrawingMode.pencil),
                  tooltip: 'Pencil',
                ),
                IconBox(
                  selected: viewModel.drawingMode == DrawingMode.line,
                  onTap: () => viewModel.setDrawingMode(DrawingMode.line),
                  tooltip: 'Line',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 22,
                        height: 2,
                        color: viewModel.drawingMode == DrawingMode.line
                            ? Colors.grey[900]
                            : Colors.grey,
                      ),
                    ],
                  ),
                ),
                IconBox(
                  iconData: Icons.hexagon_outlined,
                  selected: viewModel.drawingMode == DrawingMode.polygon,
                  onTap: () => viewModel.setDrawingMode(DrawingMode.polygon),
                  tooltip: 'Polygon',
                ),
                IconBox(
                  iconData: FontAwesomeIcons.eraser,
                  selected: viewModel.drawingMode == DrawingMode.eraser,
                  onTap: () => viewModel.setDrawingMode(DrawingMode.eraser),
                  tooltip: 'Eraser',
                ),
                IconBox(
                  iconData: FontAwesomeIcons.square,
                  selected: viewModel.drawingMode == DrawingMode.square,
                  onTap: () => viewModel.setDrawingMode(DrawingMode.square),
                  tooltip: 'Square',
                ),
                IconBox(
                  iconData: FontAwesomeIcons.circle,
                  selected: viewModel.drawingMode == DrawingMode.circle,
                  onTap: () => viewModel.setDrawingMode(DrawingMode.circle),
                  tooltip: 'Circle',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Fill Shape: ',
                  style: TextStyle(fontSize: 12),
                ),
                Checkbox(
                  value: viewModel.filled,
                  onChanged: (val) {
                    viewModel.setFilled(val ?? false);
                  },
                ),
              ],
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: viewModel.drawingMode == DrawingMode.polygon
                  ? Row(
                      children: [
                        const Text(
                          'Polygon Sides: ',
                          style: TextStyle(fontSize: 12),
                        ),
                        Slider(
                          value: viewModel.polygonSides.toDouble(),
                          min: 3,
                          max: 8,
                          onChanged: (val) {
                            viewModel.setPolygonSides(val.toInt());
                          },
                          label: '${viewModel.polygonSides}',
                          divisions: 5,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 5),
          ],
        ),
      );
    });
  }
}
