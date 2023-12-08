// import 'package:Fahren123/controller/order_controller.dart';
// import 'package:Fahren123/util/dimensions.dart';
// import 'package:Fahren123/util/styles.dart';
// import 'package:Fahren123/view/base/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class ConfirmationDialog extends StatelessWidget {
//   final String icon;
//   final String title;
//   final String description;
//   final Function onYesPressed;
//   final bool isLogOut;
//   final Function onNoPressed;
//   const ConfirmationDialog({Key? key, required this.icon, this.title, required this.description, required this.onYesPressed,
//     this.isLogOut = false, this.onNoPressed}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
//       insetPadding: const EdgeInsets.all(30),
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       child: SizedBox(width: 500, child: Padding(
//         padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//
//           Padding(
//             padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//             child: Image.asset(icon, width: 50, height: 50, color: Theme.of(context).primaryColor),
//           ),
//
//           title != null ? Padding(
//             padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
//             child: Text(
//               title, textAlign: TextAlign.center,
//               style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.red),
//             ),
//           ) : const SizedBox(),
//
//           Padding(
//             padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//             child: Text(description, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
//           ),
//           const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
//
//           GetBuilder<OrderController>(builder: (orderController) {
//             return !orderController.isLoading ? Row(children: [
//               Expanded(child: TextButton(
//                 onPressed: () => isLogOut ? onYesPressed() : onNoPressed != null ? onNoPressed() : Get.back(),
//                 style: TextButton.styleFrom(
//                   backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: const Size(Dimensions.WEB_MAX_WIDTH, 50), padding: EdgeInsets.zero,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
//                 ),
//                 child: Text(
//                   isLogOut ? 'yes'.tr : 'no'.tr, textAlign: TextAlign.center,
//                   style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
//                 ),
//               )),
//               const SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
//
//               Expanded(child: CustomButton(
//                 buttonText: isLogOut ? 'no'.tr : 'yes'.tr,
//                 onPressed: () => isLogOut ? Get.back() : onYesPressed(),
//                 radius: Dimensions.RADIUS_SMALL, height: 50,
//               )),
//             ]) : const Center(child: const CircularProgressIndicator());
//           }),
//
//         ]),
//       )),
//     );
//   }
// }
