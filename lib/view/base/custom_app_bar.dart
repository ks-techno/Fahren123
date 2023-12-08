import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Fahren123/util/styles.dart';

import '../../util/color_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String ?title;
  final Widget ?leading;
  final bool showLeading;
  final Color leadingIconColor;
  final List<Widget> trailing;
  final Function ?onBack;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.leading,
    this.onBack,
    List<Widget> ?trailing,
    this.showLeading = true,
    this.leadingIconColor= Colors.grey,
  }):trailing = trailing??const <Widget>[] , super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: PreferredSize(
        preferredSize: Size(deviceSize.width,deviceSize.height*.05),

        child: ListTile(
         
          leading: !showLeading ? const SizedBox(): Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: leadingIconColor==Colors.white?Colors.black26:null,
              border: Border.all(color: leading != null ? Colors.white :leadingIconColor),
            ),
              margin: const EdgeInsets.only(left: 10),
              child: leading ?? InkWell(
                  radius: 100,
                  borderRadius: BorderRadius.circular(100),
                  onTap: (){
                    if(onBack!=null){
                      onBack!();
                    }else{
                      Get.back();
                    }
                 },
                  child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(Icons.arrow_back,color: leadingIconColor,),
              ))),
          contentPadding: const EdgeInsets.all(0),
          title: title!=null?Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  child: Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: ralewayMedium.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ),
            ],
          ):const SizedBox(),
          trailing: trailing.isEmpty?const SizedBox(width: 45,): Wrap(
            alignment: WrapAlignment.end,
            children: trailing,
          ),
        ),

      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, GetPlatform.isDesktop ? 70 : 50);
}
