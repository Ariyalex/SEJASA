import 'package:flutter/material.dart';

class MyOutlineButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  const MyOutlineButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 18)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
