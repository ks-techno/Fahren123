import 'dart:convert';
import 'dart:developer';

import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/data/repository/auth_repo.dart';
import 'package:Fahren123/enums/otp_verify_type.dart';
import 'package:Fahren123/helper/route_helper.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/view/base/custom_app_bar.dart';
import 'package:Fahren123/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../util/app_strings.dart';
import '../../../util/styles.dart';
import '../../base/my_text_field.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();


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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(AppString.isForgetYourPassword.tr,
                            style: ralewayMedium.copyWith(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Padding(
                                               padding: const EdgeInsets.only(left: 12),

                      child: Text(AppString.weSendOtpToResetPassword.tr,
                        style: ralewayRegular.copyWith(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    Column(
                      children: [
                        CustomInputTextField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          isPassword: false,
                          context: context,
                          onValueChange: (_){
                            setState(() {
                              
                            });
                          },
                          hintText: AppString.email,
                          validator: (inputData) {
                            return inputData!.isEmpty
                                ? ErrorMessage.emailEmptyError
                                : inputData.length>250
                                ? ErrorMessage.emailInvalidError
                                : null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CustomButton(
                        
                        height: 50,
                        radius: 10,
                              color: _emailController.text.isNotEmpty ? null : Colors.grey.withOpacity(0.2) ,

                        buttonText: AppString.next.tr,
                        onPressed: () async {
                          if(_emailController.text.isNotEmpty){

                            SharedPreferences da = await SharedPreferences.getInstance();

                            //yahan se pehle otp verify pe le ker jana hai phr uske baad change password ki screen show kreinge
                           var resp =    await AuthRepo(sharedPreferences: da).forgetPassword(email: _emailController.text);

                           if(resp['Success']['success'] == true){
  da.setString('otp', jsonEncode(resp['Success']['result']));

                          Get.toNamed(RouteHelper.getOtpVerificationRoute(verificationType: OtpVerifyType.ForgetPassword));
                           }

                         

                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ]);
                }),
              ),
            ),
          )),
    );
  }

  void _forgetPass(String countryCode) async {


  }
}
