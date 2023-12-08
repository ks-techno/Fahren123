// import 'package:Fahren123/controller/auth_controller.dart';
// import 'package:Fahren123/helper/route_helper.dart';
// import 'package:Fahren123/util/dimensions.dart';
// import 'package:Fahren123/util/styles.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ConditionCheckBox extends StatelessWidget {
//   final AuthController authController;
//   ConditionCheckBox({required this.authController});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(children: [
//       Checkbox(
//         activeColor: Theme.of(context).primaryColor,
//         value: authController.acceptTerms,
//         onChanged: (bool isChecked) => authController.toggleTerms(),
//       ),
//       Text('i_agree_with'.tr, style: robotoRegular),
//       InkWell(
//         onTap: () => Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition')),
//         child: Padding(
//           padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
//           child: Text('terms_conditions'.tr, style: robotoMedium.copyWith(color: Colors.blue)),
//         ),
//       ),
//     ]);
//   }
// }
