import 'package:flutter/material.dart';
import 'package:pickit/components/app_bar.dart';
import 'package:pickit/constants/strings.dart';
import 'package:pickit/view/picker_view.dart';

class PickerScreen extends StatelessWidget {
  const PickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          title: Strings.screenTitle,
        ),
        body: PickerView(),
      ),
    );
  }
}
