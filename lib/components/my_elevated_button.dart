import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton({
    super.key,
    required this.title,
    required this.onClick,
  });
  final String title;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onClick, child: Text(title));
  }
}
