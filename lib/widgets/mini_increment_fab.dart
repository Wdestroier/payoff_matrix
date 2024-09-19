import 'package:flutter/material.dart';

class MiniIncrementFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const MiniIncrementFab({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      mini: true,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Icon(icon),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.scale(
              scale: 0.5,
              child: const Icon(Icons.exposure_plus_1),
            ),
          ),
        ],
      ),
    );
  }
}
