import 'package:flutter/material.dart';

class RawButton extends StatelessWidget {
  final IconData icon;
  final Widget? child;
  final BuildContext context;
  final Function(BuildContext context)? onPressed;
  final String tooltip;
  const RawButton({
    super.key,
    required this.icon,
    this.child,
    this.onPressed,
    required this.context,
    this.tooltip = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: RawMaterialButton(
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0.1,
        shape: const CircleBorder(),
        fillColor: Colors.white,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        highlightColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).primaryColor
            : Colors.black12.withOpacity(onPressed != null ? .5 : .1),
        splashColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).primaryColor.withOpacity(.05)
            : Colors.black12.withOpacity(onPressed != null ? .5 : .1),
        constraints: const BoxConstraints.expand(
          width: 35,
          height: 35,
        ),
        onPressed: () {
          onPressed?.call(context);
        },
        child: Tooltip(
          message: tooltip,
            preferBelow: false,
          child: child ??
              Icon(
                icon,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black12.withOpacity(onPressed != null ? .5 : .1),
                size: 20,
              ),
        ),
      ),
    );
  }
}
