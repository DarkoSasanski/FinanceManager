import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final String actionButtonText;
  final VoidCallback actionButtonOnPressed;
  final List<Color> gradientColors;

  const CustomActionButton(
      {super.key,
      required this.actionButtonText,
      required this.actionButtonOnPressed,
      required this.gradientColors});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        shape: const StadiumBorder(),
        padding: EdgeInsets.zero,
        elevation: 0,
      ).copyWith(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: actionButtonOnPressed,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            actionButtonText,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
