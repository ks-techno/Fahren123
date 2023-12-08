import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Utils/utils.dart';
import 'package:get/get.dart';

class CustomImagePickerScreen extends StatefulWidget {
  final bool showImagePicker;
  const CustomImagePickerScreen({Key? key, this.showImagePicker = true})
      : super(key: key);

  @override
  CameraPickerScreenState createState() => CameraPickerScreenState();
}

class CameraPickerScreenState extends State<CustomImagePickerScreen>
    with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  XFile? pickedImage;
  CameraController? cameraController;
  bool isCameraInitializing = true;
  bool isTorchOn = false;
  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameraList) {
      cameras = availableCameraList;
      if (cameras.isNotEmpty) {
        cameraController = CameraController(
          cameras[0],
          kIsWeb ? ResolutionPreset.max : ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );
        cameraController!.initialize().then((_) {
          if (!mounted) {
            return;
          }
          cameraController!.setFlashMode(FlashMode.off);
          isCameraInitializing = false;
          setState(() {});
        });
      } else {
        isCameraInitializing = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        onBackButtonPressed();
        return false;
      },
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: onBackButtonPressed,
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.white,
              ),
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              pickedImage == null ? "Image Picker" : "Picked Image",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            actions: [
              /// Image Cropper
              pickedImage != null
                  ? IconButton(
                      onPressed: () {
                        cropImage(imageToBeCroppedPath: pickedImage!.path)
                            .then((croppedImage) {
                          if (croppedImage != null) {
                            pickedImage = croppedImage;
                            setState(() {});
                          }
                        });
                      },
                      iconSize: 25,
                      icon: const Icon(
                        Icons.crop,
                        color: Colors.white,
                      ))
                  : const SizedBox(),

              /// Image picker done
              pickedImage == null
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        Get.back(
                            result: {"pickedImage": File(pickedImage!.path)});
                      },
                      iconSize: 25,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      )),
              SizedBox(
                width: pickedImage == null ? 0 : 5,
              ),
              pickedImage == null
                  ? IconButton(
                      onPressed: () {
                        isTorchOn = !isTorchOn;
                        if (isTorchOn) {
                          cameraController!.setFlashMode(FlashMode.torch);
                        } else {
                          cameraController!.setFlashMode(FlashMode.off);
                        }
                        setState(() {});
                      },
                      icon: isTorchOn
                          ? Icon(Icons.flashlight_on,
                              color: Theme.of(context).primaryColorDark)
                          : Icon(Icons.flashlight_off_outlined,
                              color: Theme.of(context).primaryColorDark),
                    )
                  : const SizedBox(),
            ],
          ),
          body: Container(
            constraints:
                pickedImage == null ? BoxConstraints.tight(deviceSize) : null,
            alignment: Alignment.center,
            child: cameras.isEmpty
                ? const Text(
                    "Camera is not available on this device",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                : pickedImage == null
                    ? _cameraPickerView(deviceSize)
                    : _pickedImageView(deviceSize),
          ),
        ),
      ),
    );
  }

  Widget _cameraPickerView(Size deviceSize) {
    return Column(
      children: [
        (cameraController?.value.isInitialized ?? false)
            ? Expanded(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CameraPreview(cameraController!),
                ),
              )
            : const SizedBox(),
        (cameraController?.value.isInitialized ?? false)
            ? const SizedBox()
            : Expanded(
                child: Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: Text(
                    isCameraInitializing
                        ? "Initializing Camera"
                        : "Camera is not initialized",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
        const SizedBox(
          height: 5,
        ),

        /// Camera Controls
        SizedBox(width: deviceSize.width, child: _buildCameraControls()),
        const SizedBox(
          height: 5,
        ),
        const Text(
          'Tap for photo',
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _pickedImageView(Size deviceSize) {
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            color: Colors.black),
        child: Image.file(
          File(pickedImage!.path),
          // fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildCameraControls() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        widget.showImagePicker
            ? IconButton(
                icon: const Icon(Icons.photo_library),
                color: Colors.white,
                onPressed: () async {
                  isTorchOn = false;
                  cameraController!.setFlashMode(FlashMode.off);
                  pickedImage = await pickGalleryImage(context: context);
                  setState(() {});
                })
            : const IconButton(
                icon: Icon(null), color: Colors.transparent, onPressed: null),
        GestureDetector(
          child: const SizedBox(
            height: 70,
            width: 70,
            child: CircularProgressIndicator(
              value: 1.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          onTap: () async {
            pickedImage = await pickCameraImage(
                context: context, cameraController: cameraController);
            isTorchOn = false;
            cameraController!.setFlashMode(FlashMode.off);
            setState(() {});
          },
        ),
        const IconButton(
            icon: Icon(null), color: Colors.transparent, onPressed: null),
      ],
    );
  }

  void Function()? onBackButtonPressed() {
    if (pickedImage == null) {
      Get.back();
    } else {
      pickedImage = null;
      setState(() {});
    }
    return null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (cameraController == null ||
        !(cameraController?.value.isInitialized ?? false)) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (cameraController != null) {
        onNewCameraSelected(cameraController!.description);
      }
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController?.dispose();
    }

    cameraController = CameraController(
      cameras[0],
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    cameraController = cameraController;

    // If the controller is updated then update the UI.
    cameraController?.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if ((cameraController?.value.hasError ?? true)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Error: ${cameraController?.value.errorDescription ?? "Camera not initialized"}')));
      }
    });

    try {
      await cameraController?.initialize();
    } on CameraException catch (e) {
      try {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: ${e.description}')));
      } catch (e) {
        debugPrint("Exception:-> $e");
      }
    }

    if (mounted) {
      setState(() {});
    }
  }
}
