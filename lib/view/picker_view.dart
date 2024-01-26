import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pickit/components/my_elevated_button.dart';
import 'package:pickit/constants/colours.dart';
import 'package:pickit/constants/strings.dart';
import 'package:pickit/view/picker_view_model.dart';
import 'package:video_player/video_player.dart';

class PickerView extends StatefulWidget {
  const PickerView({super.key});

  @override
  State<PickerView> createState() => _PickerViewState();
}

class _PickerViewState extends State<PickerView> {
  @override
  void initState() {
    super.initState();
  }

  bool isVideoFile(String filePath) {
    // Get the file extension
    String extension = filePath.split('.').last.toLowerCase();

    // Check if the extension corresponds to a video format
    return [
      'mp4', 'avi', 'mkv', 'mov', 'wmv', 'flv', 'webm', // Add more video extensions if needed
    ].contains(extension);
  }

  bool isImageFile(String filePath) {
    // Get the file extension
    String extension = filePath.split('.').last.toLowerCase();

    // Check if the extension corresponds to an image format
    return [
      'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', // Add more image extensions if needed
    ].contains(extension);
  }

  final PickerViewModel ctrl = Get.put(PickerViewModel());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _showOptions(context),
            ctrl.pickedMedia.isEmpty
                ? SizedBox(
                    height: 250.h,
                  )
                : Container(),
            ctrl.pickedMedia.isEmpty ? _noMediaView() : _mediaView(),
          ],
        ),
      ),
    );
  }

  Widget _showOptions(context) {
    return MyElevatedButton(
      title: Strings.chooseFile,
      onClick: () async {
        await ctrl.showOptions(context);
        setState(() {});
      },
    );
  }

  Widget _noMediaView() {
    return const Align(
      alignment: Alignment.bottomCenter,
      child: Text(Strings.noMediaSelected),
    );
  }

  Widget _mediaView() {
    return GetBuilder<PickerViewModel>(
      builder: (controller) => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20.h,
          crossAxisSpacing: 20.w,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ctrl.pickedMedia.length,
        itemBuilder: (context, index) {
          final mediaFile = ctrl.pickedMedia[index];
          // return mediaFile?.mediaType == Strings.image
          return isImageFile(ctrl.pickedMedia[index]!.path) ? _image(index)
              : _video(index);

        },
      ),
    );
  }

  Widget _image(index) {
    final mediaFile = ctrl.pickedMedia[index];
    return GestureDetector(
      onTap: () {
        log("Image ${index + 1}");
      },
      onLongPress: () => ctrl.deleteSelectedImage(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colours.mediaBackground,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Image.file(
          File(mediaFile?.path ?? ""),
          // File(mediaFile?.xFile.path ?? ""),
        ),
      ),
    );
  }

  Widget _video(index) {
    return GestureDetector(
      onLongPress: () => ctrl.deleteSelectedImage(index),
      child: AspectRatio(
        aspectRatio: ctrl.videoPlayerController.value.aspectRatio,
        child: VideoPlayer(ctrl.videoPlayerController),
      ),
    );
  }
}
