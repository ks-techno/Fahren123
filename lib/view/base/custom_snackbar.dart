import 'package:Fahren123/helper/responsive_helper.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Fahren123/util/styles.dart';

void showCustomSnackBar(String message, {bool isError = true}) {
  if(message.isNotEmpty) {
    BotToast.showSimpleNotification(
      title: message,
      subTitle: null,
      enableSlideOff: true,
      hideCloseButton: true,
      dismissDirections: const [DismissDirection.up],
      borderRadius: Dimensions.RADIUS_SMALL,
      align: Alignment.topCenter,
      backgroundColor: isError ? Colors.red : Colors.green,
      titleStyle: ralewayMedium.copyWith(color: Colors.white),
      subTitleStyle: ralewayMedium.copyWith(color: Colors.white),
      onlyOne: true,
      crossPage: true,
      animationDuration: const Duration(milliseconds: 200),
      animationReverseDuration: const Duration(milliseconds: 200),
      duration: const Duration(seconds: 3),
    );


    // ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    //   dismissDirection: DismissDirection.horizontal,
    //   margin: EdgeInsets.only(
    //     right: ResponsiveHelper.isDesktop(Get.context) ? Get.context!.width*0.7 : Dimensions.PADDING_SIZE_SMALL,
    //     top: Dimensions.PADDING_SIZE_SMALL, bottom: Dimensions.PADDING_SIZE_SMALL, left: Dimensions.PADDING_SIZE_SMALL,
    //   ),
    //   duration: const Duration(seconds: 3),
    //   backgroundColor: isError ? Colors.red : Colors.green,
    //   behavior: SnackBarBehavior.floating,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
    //   content: Text(message, style: ralewayMedium.copyWith(color: Colors.white)),
    // ));
  }
}