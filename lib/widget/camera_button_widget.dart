import 'package:flutter/material.dart';

class CameraCapturingButtonWidget extends StatelessWidget {
  const CameraCapturingButtonWidget(
      {Key? key,
        required this.onPressed,
        required this.icon,
        required this.size})
      : super(key: key);

  final VoidCallback onPressed;

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: CircleAvatar(
        backgroundColor: Colors.grey.shade800,
        maxRadius: (size > 30) ? size - 10 : size - 5,
        child: Icon(
          icon,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }
}
