import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickit/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class PickerViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadSelectedMedia();
    // videoPlayerController.play();
    // _getVideoFromCamera();
    // _getVideoFromGallery();
  }

  RxList<XFile?> pickedMedia = <XFile?>[].obs;

  // RxList<MediaFile?> pickedMedia = <MediaFile?>[].obs;
  RxString mediaType = Strings.image.obs;
  late File cameraImage;
  late File galleryImage;
  File? cameraVideo;
  late File galleryVideo;
  late VideoPlayerController videoPlayerController;
  final picker = ImagePicker();

  Future<void> showOptions(context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Get.back();
              _getImageFromCamera();
            },
            child: const Text(Strings.selectImageFromCamera),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Get.back();
              _getImageFromGallery();
            },
            child: const Text(Strings.selectImageFromGallery),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Get.back();
              _getVideoFromCamera();
            },
            child: const Text(Strings.selectVideoFromCamera),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Get.back();
              _getVideoFromGallery();
            },
            child: const Text(Strings.selectVideoFromGallery),
          ),
        ],
      ),
    );
  }

  Future<void> _getImageFromCamera() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    File image = File(pickedFile?.path ?? "");
    cameraImage = image;
    if (pickedFile != null) {
      // MediaFile mediaFile = MediaFile(pickedFile, Strings.image);
      final mediaFile = XFile(pickedFile.path);
      pickedMedia.add(mediaFile);
      saveSelectedMedia();
      mediaType.value = Strings.image;
      update();
    }
  }

  Future<void> _getImageFromGallery() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    File image = File(pickedFile?.path ?? "");
    galleryImage = image;
    if (pickedFile != null) {
      // MediaFile mediaFile = MediaFile(pickedFile, Strings.image);
      final mediaFile = XFile(pickedFile.path);
      pickedMedia.add(mediaFile);
      saveSelectedMedia();
      mediaType.value = Strings.image;
      update();
    }
  }

  Future<void> _getVideoFromCamera() async {
    XFile? pickedFile = await picker.pickVideo(source: ImageSource.camera);
    File video = File(pickedFile?.path ?? "");
    cameraVideo = video;
    if (pickedFile != null) {
      // MediaFile mediaFile = MediaFile(pickedFile, Strings.video);
      final mediaFile = XFile(pickedFile.path);
      pickedMedia.add(mediaFile);
      videoPlayerController =
          VideoPlayerController.file(cameraVideo ?? File(""))
            ..initialize().then((value) {
              videoPlayerController.play();
              saveSelectedMedia();
              mediaType.value = Strings.video;
              update();
            });
    }
  }

  Future<void> _getVideoFromGallery() async {
    XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    File video = File(pickedFile?.path ?? "");
    galleryVideo = video;
    if (pickedFile != null) {
      // MediaFile mediaFile = MediaFile(pickedFile, Strings.video);
      final mediaFile = XFile(pickedFile.path);
      pickedMedia.add(mediaFile);
      videoPlayerController = VideoPlayerController.file(galleryVideo)
        ..addListener(() {
          update();
        })
        ..setLooping(false)
        ..initialize().then((value) {
          videoPlayerController.play();
          // update();
          saveSelectedMedia();
          mediaType.value = Strings.video;
          update();
        });
    }
  }

  Future<void> saveSelectedMedia() async {
    final prefs = await SharedPreferences.getInstance();
    // final mediaPaths = pickedMedia.map((file) => file?.xFile.path).toList();
    final mediaPaths = pickedMedia.map((file) => file?.path).toList();
    prefs.setString(Strings.selectedMedia, jsonEncode(mediaPaths));
    update();
  }

  Future<void> loadSelectedMedia() async {
    final prefs = await SharedPreferences.getInstance();
    final mediaPaths = prefs.getString(Strings.selectedMedia);
    log("Paths: $mediaPaths");
    if (mediaPaths != null) {
      final paths = jsonDecode(mediaPaths).cast<String>();
      pickedMedia.value = paths.map<XFile?>((path) => XFile(path)).toList();
      update();
    }
  }

  void deleteSelectedImage(int index) {
    if (index >= 0 && index < pickedMedia.length) {
      pickedMedia.removeAt(index);
      saveSelectedMedia();
      update();
    }
  }
}

// class MediaFile {
//   XFile xFile;
//   String mediaType;
//
//   MediaFile(this.xFile, this.mediaType);
//
//   Map<String, dynamic> toJson(MediaFile instance) =>
//       <String, dynamic>{
//   "xFile": instance.xFile,
//   "mediaType": instance.mediaType,
//   };
// }


