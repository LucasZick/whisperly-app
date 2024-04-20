import 'dart:async';

import 'package:flutter/material.dart';

class IconOpeningHoverable extends StatefulWidget {
  const IconOpeningHoverable(
      {super.key,
      required this.size,
      required this.onPressed,
      this.hoveredIcon = Icons.play_arrow_rounded});
  final double size;
  final VoidCallback? onPressed;
  final IconData? hoveredIcon;

  @override
  State<IconOpeningHoverable> createState() => _IconOpeningHoverableState();
}

class _IconOpeningHoverableState extends State<IconOpeningHoverable> {
  late Timer _timer;
  int _currIndex = 0;

  Map iconByIndex = {
    0: Icons.circle,
    1: Icons.circle_outlined,
  };

  getIcon() => iconByIndex[_currIndex];

  changeCurrIndex(int index) {
    setState(() {
      _currIndex = index;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currIndex != 2) {
        setState(() {
          _currIndex = (_currIndex + 1) % 2;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    iconByIndex[2] = widget.hoveredIcon;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => changeCurrIndex(2),
      onExit: (_) => changeCurrIndex(0),
      child: TextButton(
        onPressed: widget.onPressed,
        child: AnimatedSwitcher(
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, anim) => RotationTransition(
            turns: child.key == const ValueKey('icon1')
                ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                : Tween<double>(begin: 0.75, end: 1).animate(anim),
            child: ScaleTransition(scale: anim, child: child),
          ),
          child: Icon(
            getIcon(),
            key: ValueKey('icon$_currIndex'),
            size: widget.size,
          ),
        ),
      ),
    );
  }
}
