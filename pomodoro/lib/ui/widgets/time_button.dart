import 'package:flutter/material.dart';

class TimeButtons extends StatefulWidget {
  final Color buttonColor;
  final VoidCallback onPressed;
  final Icon icon;

  const TimeButtons({required this.icon, required this.buttonColor, required this.onPressed, Key? key}) : super(key: key);

  @override
  State<TimeButtons> createState() => _TimeButtonsState();
}

class _TimeButtonsState extends State<TimeButtons> {
  late Color color;
  late VoidCallback onPressed;
  late Icon icon;

  @override
  void initState() {
    super.initState();
    color = widget.buttonColor;
    onPressed = widget.onPressed;
    icon = widget.icon;
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: icon,
            color: color,
            onPressed: onPressed,iconSize: 35,disabledColor: Colors.orangeAccent,splashColor: Colors.amber,
        ),],
    );

  }
}