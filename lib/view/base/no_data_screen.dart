import 'package:Fahren123/util/images.dart';
import 'package:Fahren123/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoDataScreen extends StatelessWidget {
  final bool isCart;
  final String text;
  const NoDataScreen({required this.text, this.isCart = false,});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [

        Image.asset(
          isCart ? Images.empty_cart : Images.no_data_found,
          width: MediaQuery.of(context).size.height*0.15, height: MediaQuery.of(context).size.height*0.15,
        ),
        SizedBox(height: MediaQuery.of(context).size.height*0.03),

        Text(
          isCart ? 'cart_is_empty'.tr : text,
          style: ralewayMedium.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).disabledColor),
          textAlign: TextAlign.center,
        ),

      ]),
    );
  }
}
