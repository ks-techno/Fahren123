import 'package:Fahren123/util/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../util/styles.dart';

class GenderWidget extends StatelessWidget {
  final bool isSelected;
  final String title;
  final void Function() onPressed;
  const GenderWidget({Key? key, required this.title, required this.onPressed, this.isSelected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.only(right: 10,top: 5,bottom: 5),
        child: Row(
          children: [
            Container(
              height: 15,
              width: 15,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: isSelected? AppColor.appMainGradient : null,
                color: isSelected? null :Theme.of(context).primaryColorDark,
                border: Border.all(color: Colors.black,),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 2,),
            Text(
              title.tr,
              style: ralewayMedium.copyWith(fontSize: 13,fontWeight: isSelected? FontWeight.w600: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
