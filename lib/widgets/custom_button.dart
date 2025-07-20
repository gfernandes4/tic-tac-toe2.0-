import 'package:flutter/material.dart';
import '../theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: color ?? Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}),
        minimumSize: const Size.fromHeight(48),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}