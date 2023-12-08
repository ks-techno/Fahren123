import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Fahren123/util/app_constants.dart';
import 'package:Fahren123/util/styles.dart';
import '../../util/app_strings.dart';
import '../../util/images.dart';
import 'custom_button.dart';

Future<bool> showCustomDialog({required BuildContext context, required String descriptions,required String title, })async{
  bool isConfirmed = false;
  await showDialog(context: context,
      builder: (BuildContext context){
        return CustomDialogBox(
          descriptions: descriptions,
          title: title,
          onPress:(bool value){
            isConfirmed = value;
          },
        );
      });
  return isConfirmed;
}

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions;
  final Function (bool isConfirmed)onPress;

   const CustomDialogBox({Key? key, required this.title,required this.descriptions, required this.onPress}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}
  class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: AppConstants.padding,top: AppConstants.avatarRadius
              + AppConstants.padding, right: AppConstants.padding,bottom: AppConstants.padding
          ),
          margin: const EdgeInsets.only(top: AppConstants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(AppConstants.padding),
              boxShadow: const [
                BoxShadow(color: Colors.black,offset: Offset(0,1),
                    blurRadius: 6
                ),
              ]
          ),
          child: Column(

            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.title,style: ralewayMedium.copyWith(fontSize: 20),),
              const SizedBox(height: 5,),
              Text(widget.descriptions,style: ralewayRegular.copyWith(fontSize: 14),),
              const SizedBox(height: 25,),
              Row(
                children: [
                 // const Spacer(),
                  Expanded(
                     child: CustomButton(
                       onPressed: () {
                         widget.onPress(false);
                         Get.back();
                       },
                       radius: 10,
                       buttonText: AppString.no,

              )),
                  const SizedBox(width: 10,),
                  Expanded(
                    child:  CustomButton(
                      onPressed: () {
                        widget.onPress(true);
                        Get.back();
                      },
                      radius: 10,
                      buttonText: AppString.yes,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: AppConstants.padding,
          right: AppConstants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: AppConstants.avatarRadius,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.avatarRadius)),
              child: Image.asset(Images.alertDialogBox,color: Theme.of(context).primaryColor,),
            ),
          ),
        ),
      ],
    );
  }
}

