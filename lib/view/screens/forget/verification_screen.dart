import 'dart:async';
import 'dart:convert';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/view/base/custom_app_bar.dart';
import 'package:Fahren123/view/base/my_text_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/auth_controller.dart';
import '../../../enums/otp_verify_type.dart';
import '../../../util/app_strings.dart';
import '../../../util/styles.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';

class OtpVerificationScreen extends StatefulWidget {
  final OtpVerifyType verifyType;
  final int? userId;
  const OtpVerificationScreen({Key? key, required this.verifyType, required this.userId,}) : super(key: key);

  @override
  OtpVerificationScreenState createState() => OtpVerificationScreenState();
}

class OtpVerificationScreenState extends State<OtpVerificationScreen> {

  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();
  TextEditingController otpPinController = TextEditingController();
  String otpCode = '';


  @override
  void initState() {
    super.initState();
  }

  // void _startTimer() {
  //   _seconds = 60;
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     _seconds = _seconds - 1;
  //     if(_seconds == 0) {
  //       timer?.cancel();
  //       _timer?.cancel();
  //     }
  //     setState(() {});
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    // _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const CustomAppBar(title: null, leading: null,showLeading: true,),
      body: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: context.width,
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                margin: EdgeInsets.zero,
                child: GetBuilder<AuthController>(builder: (authController) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(AppString.otpAuthentication.tr,
                                style: ralewayMedium.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        // Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge))),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(AppString.otpSentToEmail.tr,
                                  style: ralewayRegular.copyWith(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        Column(
                          children: [
                            PinCodeTextField(
                              length: 4,
                              obscureText: false,
                              animationType: AnimationType.fade,
                              inputFormatters:[FilteringTextInputFormatter.digitsOnly],
                              keyboardType: getKeyboardTypeForDigitsOnly(),
                              pinTheme: PinTheme(
                                fieldHeight: 60,
                                fieldWidth: 60,
                                borderWidth: 0,
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                selectedColor: Theme.of(context).backgroundColor,
                                selectedFillColor: Theme.of(context).backgroundColor,
                                activeFillColor: Theme.of(context).backgroundColor,
                                activeColor: Theme.of(context).backgroundColor,
                                inactiveFillColor: Theme.of(context).backgroundColor,
                                inactiveColor: Theme.of(context).backgroundColor,
                                errorBorderColor: Theme.of(context).errorColor,
                              ),
                              textStyle: ralewayMedium.copyWith(fontSize: 24),
                              enableActiveFill: true,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              animationDuration: const Duration(milliseconds: 300),
                              backgroundColor: Colors.transparent,
                              errorAnimationController: errorController,
                              controller: otpPinController,
                              onChanged: (value) {
                                otpCode = value;
                              },
                              beforeTextPaste: (text) {
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return false;
                              },
                              appContext: context,
                            )
                          ],
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                width: 140,
                                height: 50,
                                radius: 10,
                                buttonText: AppString.conTinue.tr,
                                onPressed: (){
                                  if(otpCode.length<4){
                                    onInvalidOtpEntered();
                                  }else{
                                    _otpVerified(authController);
                                  }
                                },
                              ),
                            ]),
                        const SizedBox(height: 30),
                      ]);
                }),
              ),
            ),
          )),
    );
  }
  void _otpVerified(AuthController authController,) async{
    debugPrint("widget.userId:-> ${widget.userId}");
    String otpPin = otpPinController.text;
    if(widget.userId!=null){
      bool isVerified = await authController.verifyOtp(int.parse(otpPin), widget.verifyType, widget.userId!);
      if(!isVerified){
        onInvalidOtpEntered();
      }
    }else{
      if(widget.verifyType  ==  OtpVerifyType.ForgetPassword ){

      //userId null hai iska matlab hum login side se aaye ha

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String email = '';

      try{
      var da = jsonDecode(prefs.getString('otp')!);

      email = da['email'];

      }catch(e){}



      

      bool isVerified = await authController.forgetVerifyOtp(int.parse(otpPin), widget.verifyType, email);
      if(!isVerified){
        onInvalidOtpEntered();
      }




      }
    }
  }
  void onInvalidOtpEntered(){
    errorController.add(ErrorAnimationType.shake);
    showCustomSnackBar('Enter valid otp code to continue'.tr);
  }
}