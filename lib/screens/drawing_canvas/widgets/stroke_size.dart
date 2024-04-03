import 'package:drote/core/view_models/interfaces/iboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StrokeSizeWidget extends StatelessWidget {
  const StrokeSizeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IBoardViewModel>(
      builder: (_, viewmodel, __) {
        return Padding(
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
                    value: viewmodel.strokeSize,
                    min: 0,
                    max: 50,
                    onChanged: (val) {
                      viewmodel.setStrokeSize(val);
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
                    value: viewmodel.eraserSize,
                    min: 0,
                    max: 80,
                    onChanged: (val) {
                      viewmodel.setEraserSize(val);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
