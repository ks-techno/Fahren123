import 'dart:io';
import 'package:Fahren123/helper/route_helper.dart';
import 'package:Fahren123/view/base/custom_snackbar.dart';
import 'package:Fahren123/view/base/loading_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

Future<XFile?> pickGalleryImage({required BuildContext context}) async {
  XFile? pickedImage;
  try {
    if (!(context.isBlank ?? true)) {
      bool isPermissionsGranted = await Permission.mediaLibrary.isGranted;

      if (isPermissionsGranted) {
        await ImagePicker()
            .pickImage(
          source: ImageSource.gallery,
          imageQuality: 100,
        )
            .then((value) async {
          if (value != null) {
            ApiLoader.show();
            pickedImage = await fetchImageFromPath(image: value);
            ApiLoader.hide();
          }
        });
      } else {
        isPermissionsGranted = await requestPermission(requiredPermissions: [
          Permission.mediaLibrary,
        ], context: context);
        pickedImage = await pickGalleryImage(context: context);
      }
    }
  } catch (e) {
    debugPrint("Exception in pickGalleryImage:-> $e");
  }
  return pickedImage;
}

Future<XFile?> pickCameraImage(
    {required CameraController? cameraController,
    required BuildContext context}) async {
  bool isPermissionsGranted = await Permission.camera.isGranted;
  XFile? capturedImage;
  if (isPermissionsGranted) {
    if (cameraController?.value.isInitialized ?? false) {
      if (!(cameraController!.value.isTakingPicture)) {
        try {
          await cameraController.takePicture().then((XFile file) {
            capturedImage = file;
          });
        } on CameraException catch (e) {
          showCustomSnackBar('${e.description}');
        }
      }
    } else {
      showCustomSnackBar('Camera is not initialized');
    }
  } else {
    isPermissionsGranted = await requestPermission(
        requiredPermissions: [Permission.camera], context: context);
    capturedImage = await pickCameraImage(
        cameraController: cameraController, context: context);
  }
  if (capturedImage != null) {
    ApiLoader.show();
    capturedImage = await fetchImageFromPath(image: capturedImage!);
    ApiLoader.hide();
  }
  return capturedImage;
}

Future<bool> requestPermission(
    {required List<Permission> requiredPermissions,
    required BuildContext context}) async {
  Map<Permission, PermissionStatus> statuses =
      await requiredPermissions.request();
  if (statuses.values.every((status) => status == PermissionStatus.granted)) {
    return true;
  } else {
    showCustomSnackBar('Permission not granted');

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Permission not granted'),
          action: SnackBarAction(
            label: "Open Settings",
            onPressed: () async {
              await openAppSettings();
            },
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint("Exception:-> $e");
    }
    return false;
  }
}

Future<XFile?> cropImage({required String imageToBeCroppedPath}) async {
  XFile? croppedImageFile;
  try {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageToBeCroppedPath,
    );
    if (croppedFile != null) {
      croppedImageFile = XFile(croppedFile.path);
    }
  } on PlatformException catch (e) {
    debugPrint('Cropper Exception: $e');
  }
  return croppedImageFile;
}

Future<File?> getImage() async {
  File? pickedImageFile;
  dynamic result = await Get.toNamed(RouteHelper.getCustomImagePickerRoute()) ??
      {"pickedImage": null};
  if (result['pickedImage'] != null) {
    pickedImageFile = result['pickedImage'];
  } else {
    debugPrint("Not Picked any Image");
  }
  return pickedImageFile;
}

Future<XFile> fetchImageFromPath({required XFile image}) async {
  XFile pickedImageFile;
  try {
    int byteLength = await image.length();
    double imageSizeInKb = byteLength / 1000;
    int quality = 100;
    int compressionPercentage = 100;
    if (imageSizeInKb > 10000) {
      quality = 65;
      compressionPercentage = 60;
    } else if (imageSizeInKb > 5000) {
      quality = 70;
      compressionPercentage = 65;
    } else if (imageSizeInKb > 1000) {
      quality = 75;
      compressionPercentage = 70;
    } else if (imageSizeInKb > 500) {
      quality = 80;
      compressionPercentage = 80;
    } else if (imageSizeInKb > 100) {
      quality = 90;
      compressionPercentage = 90;
    }
    if (imageSizeInKb > 100) {
      File compressedFile = await FlutterNativeImage.compressImage(
        image.path,
        quality: quality,
        percentage: compressionPercentage,
      ).catchError((onError) {});
      pickedImageFile = XFile(compressedFile.path);
    } else {
      pickedImageFile = image;
    }
  } catch (e) {
    pickedImageFile = image;
  }
  return pickedImageFile;
}
