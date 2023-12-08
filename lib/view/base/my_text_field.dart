import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Fahren123/util/color_constants.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/util/styles.dart';

TextStyle postTextStyle({
  double fontSize = 15,
  FontWeight fontWeight = FontWeight.w400,
  String ?fontFamily,
  TextDecoration decoration = TextDecoration.none,
  Color color = Colors.black,
  FontStyle fontStyle = FontStyle.normal,
}){

  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
    decoration: decoration,
    color: color,
    fontStyle: fontStyle,
  );
}

class PostDoneButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final double minWidth;
  final Color ?backGroundColor;
  const PostDoneButton({Key? key,required this.onPressed, this.buttonText = 'Erledigt',this.minWidth=double.infinity, this.backGroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: minWidth,
      height: 40,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(33),
      ),
      color: backGroundColor??Theme.of(context).primaryColor,
      child: Text(
        buttonText,
        style: postTextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class CustomInputTextField extends StatefulWidget {

  final TextEditingController controller;
  final FocusNode ?focusNode;
  final BuildContext context;
  final double? width;
  final Color ?backgroundShadow;
  final void Function()? onTap;
  final bool readOnly;
  final String ?hintText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final String? Function(String?)? onValueChange;
  final List<TextInputFormatter> ?inputFormatters;
  final TextInputAction? textInputAction;
  final int ?minLines;
  final int ?maxLines;
  final int? maxTextLength;
  final bool obscureText;
  final bool noPadding;
  final double fieldRadius;


  const CustomInputTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.context,
    this.width,
    this.backgroundShadow,
    this.onTap,
    this.readOnly = false,
    this.hintText,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.textInputAction,
    this.minLines,
    this.maxLines,
    this.maxTextLength,
    this.validator,
    this.onValueChange,
    this.isPassword = false,
    this.obscureText = false,
    this.noPadding = false,
    this.fieldRadius = Dimensions.BORDER_RADIUS,
  }) : super(key: key);

  @override
  State<CustomInputTextField> createState() => _CustomInputTextFieldState();
}

class _CustomInputTextFieldState extends State<CustomInputTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width??double.infinity,
      padding: EdgeInsets.symmetric(horizontal: widget.noPadding? 0: 10),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        readOnly: widget.readOnly,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        inputFormatters: widget.inputFormatters,
        textInputAction: widget.textInputAction,
        textCapitalization: TextCapitalization.sentences,
        onTap: widget.onTap!=null?(){
          FocusScope.of(context).unfocus();
          widget.onTap!();
        }:null,
        onChanged: widget.onValueChange,
        maxLength: widget.maxTextLength,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        style: ralewayRegular.copyWith(fontSize: 16,),
        enabled: !widget.readOnly,
        decoration: inputFieldDecoration(context: context,hintText: widget.hintText, suffixIcon: widget.suffixIcon, fieldRadius: widget.fieldRadius),
      ),
    );
    // return Container(
    //   width: widget.width??double.infinity,
    //   padding: const EdgeInsets.symmetric(horizontal: 10),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.only(bottom: 2,left: 5),
    //         child: Text(
    //           widget.hintText??"",
    //           style: ralewayRegular.copyWith(fontSize: 12),
    //         ),
    //       ),
    //       TextFormField(
    //         controller: widget.controller,
    //         focusNode: widget.focusNode,
    //         readOnly: widget.readOnly,
    //         keyboardType: widget.keyboardType,
    //         inputFormatters: widget.inputFormatters,
    //         textInputAction: widget.textInputAction,
    //         textCapitalization: TextCapitalization.sentences,
    //         onTap: widget.onTap!=null?(){
    //           FocusScope.of(context).unfocus();
    //           widget.onTap!();
    //         }:null,
    //         onChanged: widget.onValueChange,
    //         maxLength: widget.maxTextLength,
    //         minLines: widget.minLines,
    //         maxLines: widget.maxLines,
    //         autovalidateMode: AutovalidateMode.onUserInteraction,
    //         validator: widget.validator,
    //         style: ralewayRegular.copyWith(fontSize: 16,),
    //         enabled: !widget.readOnly,
    //         decoration: inputFieldDecoration(context: context,hintText: widget.hintText, suffixIcon: widget.suffixIcon),
    //       ),
    //     ],
    //   ),
    // );
  }
}
TextInputType getKeyboardTypeForDigitsOnly(){
  return Platform.isIOS?TextInputType.datetime:TextInputType.number;
}

InputBorder inputFieldBorder({required double fieldRadius}){
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(fieldRadius),
    borderSide: const BorderSide(color: Colors.transparent),
  );
}

InputDecoration inputFieldDecoration({required BuildContext context,String ?hintText, Widget? suffixIcon, required double fieldRadius}){
  return InputDecoration(
    contentPadding: const EdgeInsets.all(15,),
    filled: true,
    fillColor:  Theme.of(context).backgroundColor,
    errorMaxLines: 2,
    errorStyle: ralewayRegular.copyWith(color: AppColor.errorColor, fontSize: 11,),
    floatingLabelStyle: ralewayRegular.copyWith(fontSize: 14,),
    hintText: hintText!=null? "${hintText} eingeben":"",
    hintStyle: ralewayRegular.copyWith(color: Theme.of(context).hintColor),
    counterStyle:  ralewayRegular.copyWith(fontSize: 14,),
    suffixIcon: suffixIcon,
    suffixIconColor: Colors.black,
    disabledBorder: inputFieldBorder(fieldRadius: fieldRadius),
    enabledBorder: inputFieldBorder(fieldRadius: fieldRadius),
    border: inputFieldBorder(fieldRadius: fieldRadius),
    errorBorder: inputFieldBorder(fieldRadius: fieldRadius),
    focusedBorder: inputFieldBorder(fieldRadius: fieldRadius),
    focusedErrorBorder: inputFieldBorder(fieldRadius: fieldRadius),
  );
}
