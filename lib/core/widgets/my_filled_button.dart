import 'package:flutter/material.dart';

class MyFilledButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  const MyFilledButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 18)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
