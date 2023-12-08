import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../util/app_constants.dart';
import '../../util/app_strings.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';

Future<bool> messageShowDialog({required String descriptions, })async{
  bool isConfirmed = false;
  debugPrint("messageShowDialog function:-> ");
  await Get.dialog(CustomDialogBox(
    descriptions: descriptions,
    onPress:(bool value){
      isConfirmed = value;
      Get.back();
    },
  ));
  // await showDialog(
  //     context: context,
  //     builder: (BuildContext context){
  //       return CustomDialogBox(
  //         descriptions: descriptions,
  //         onPress:(bool value){
  //           isConfirmed = value;
  //         },
  //       );
  //     });
  return isConfirmed;
}

class CustomDialogBox extends StatefulWidget {
  final String  descriptions;
  final Function (bool isConfirmed)onPress;

  const CustomDialogBox({Key? key, required this.descriptions, required this.onPress}) : super(key: key);

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
          padding: const EdgeInsets.only(left: AppConstants.padding,top: AppConstants.padding
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
              Text(widget.descriptions,style: ralewayRegular.copyWith(fontSize: 14),),
              const SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                child: Container(
                  padding: const EdgeInsets.all(0),
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS),
                      border: Border.all(color: Theme.of(context).primaryColor),
                      color: Colors.transparent
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      widget.onPress(true);
                      Get.back();
                    },
                    height: 40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS),
                    ),
                    child: Text(
                        AppString.ok,
                        textAlign: TextAlign.center, style: ralewayBold.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.fontSizeDefault,
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}