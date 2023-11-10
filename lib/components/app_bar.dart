import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pickit/constants/colours.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [],
      backgroundColor: Colours.appBar,
      centerTitle: Platform.isIOS ? true : false,
      elevation: 0.0,
      title: Text(title),
    );
  }
}
