import 'dart:convert';
import 'dart:developer';

import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/data/model/response/userinfo_model.dart';
import 'package:Fahren123/data/repository/auth_repo.dart';
import 'package:Fahren123/enums/otp_verify_type.dart';
import 'package:Fahren123/helper/route_helper.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/view/base/custom_app_bar.dart';
import 'package:Fahren123/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../util/app_constants.dart';
import '../../../util/app_strings.dart';
import '../../../util/styles.dart';
import '../../base/my_text_field.dart';

class CreateOrChangePasswordScreen extends StatefulWidget {
  final bool isChangePassword;
  final String email;
  final String comingFrom;
  
  const CreateOrChangePasswordScreen({Key? key, required this.comingFrom ,required this.isChangePassword, required this.email}) : super(key: key);

  @override
  State<CreateOrChangePasswordScreen> createState() => _CreateOrChangePasswordScreenState();
}

class _CreateOrChangePasswordScreenState extends State<CreateOrChangePasswordScreen> {
  final FocusNode _oldPasswordFocus = FocusNode();
  final TextEditingController _oldPasswordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _confirmPasswordController = TextEditingController();

 bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool hidePassword3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const CustomAppBar(title: null, leading: null,showLeading: true,),
      body: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: context.width > 700 ? 700 : context.width,
                padding: context.width > 700
                    ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                    : const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                margin: context.width > 700
                    ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                    : EdgeInsets.zero,
                decoration: context.width > 700
                    ? BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius:
                  BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  boxShadow: [
                    BoxShadow(
                      color: Get.isDarkMode ? Colors.grey.shade700: Colors.grey.shade300,
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ],
                )
                    : null,
                child: GetBuilder<AuthController>(builder: (authController) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:12),
                              child: Text(AppString.createNewPassword.tr,
                                style: ralewayMedium.copyWith(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                                                            padding: const EdgeInsets.only(left:12),

                              child: Text(AppString.createNewPasswordToSignIn.tr,
                                style: ralewayRegular.copyWith(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        Column(
                          children: [
                            /// Old Password if to change password
                            widget.isChangePassword
                                ? CustomInputTextField(
                              controller: _oldPasswordController,
                              focusNode: _oldPasswordFocus,
                              isPassword: false,
                              context: context,
                              obscureText: hidePassword1,
                              maxLines: 1,
                              hintText: AppString.oldPassword,
                               suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword1 = !hidePassword1;
                                      });
                                    },
                                    icon: hidePassword1
                                        ? const Icon(
                                            Icons.visibility_off,
                                          )
                                        : const Icon(
                                            Icons.visibility,
                                          ),
                                  ),
                                validator: (inputData) {
                                  return inputData!.isEmpty
                                      ? ErrorMessage.passwordEmptyError
                                      : inputData.length<AppConstants.PASSWORD_MIN_LENGTH
                                      ?  ErrorMessage.passwordMinLengthError
                                      : inputData.length>250
                                      ? ErrorMessage.passwordMaxLengthError
                                      : null;
                                },
                            )
                                : const SizedBox(),
                            SizedBox(height: widget.isChangePassword? Dimensions.PADDING_SIZE_DEFAULT:0),
                            CustomInputTextField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              isPassword: false,
                              obscureText: hidePassword2,
                              maxLines: 1,

                               onValueChange: (_){
                                setState(() {
                                  
                                });
                              },
                              context: context,
                              hintText: AppString.password,
                               suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword2 = !hidePassword2;
                                      });
                                    },
                                    icon: hidePassword2
                                        ? const Icon(
                                            Icons.visibility_off,
                                          )
                                        : const Icon(
                                            Icons.visibility,
                                          ),
                                  ),
                                validator: (inputData) {
                                  return inputData!.isEmpty
                                      ? ErrorMessage.passwordEmptyError
                                      : inputData.length<AppConstants.PASSWORD_MIN_LENGTH
                                      ?  ErrorMessage.passwordMinLengthError
                                      : inputData.length>250
                                      ? ErrorMessage.passwordMaxLengthError
                                      : null;
                                },
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                            CustomInputTextField(
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocus,
                              isPassword: false,
                              obscureText: hidePassword3,
                              maxLines: 1,

                              onValueChange: (_){
                                setState(() {
                                  
                                });
                              },
                              context: context,
                              hintText: AppString.confirmPassword,
                               suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword3 = !hidePassword3;
                                      });
                                    },
                                    icon: hidePassword3
                                        ? const Icon(
                                            Icons.visibility_off,
                                          )
                                        : const Icon(
                                            Icons.visibility,
                                          ),
                                  ),
                              validator: (inputData) {
                                return inputData!.isEmpty
                                    ? ErrorMessage.passwordEmptyError
                                    : inputData.length<AppConstants.PASSWORD_MIN_LENGTH
                                    ?  ErrorMessage.passwordMinLengthError
                                    : inputData.length>250
                                    ? ErrorMessage.passwordMaxLengthError
                                    : null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),

                          child: CustomButton(
                            // width: 194,
                            height: 50,
                            radius: 10,
                        
                            color: _passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty && _confirmPasswordController.text == _passwordController.text? null : Colors.grey.withOpacity(0.2),
                            
                            buttonText: AppString.createPassword.tr,
                            onPressed: () async {
                                log('i m in here');
                        
                              if(_passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty && _confirmPasswordController.text == _passwordController.text){

                                log('i m in here');

                                if(widget.isChangePassword){
                                   SharedPreferences prefs = await SharedPreferences.getInstance();
                                          
                              // Get.toNamed(RouteHelper.getOtpVerificationRoute(verificationType: OtpVerifyType.ForgetPassword, isChangePassword: widget.isChangePassword));
     //yahan se pehle password change kerwaen ge
     UserInfoModel? user = await AuthRepo(sharedPreferences: prefs).getLoginUserData();
                           var resp =    await AuthRepo(sharedPreferences: prefs).changePassword(user_id: user!.id.toString(), password: _passwordController.text, oldPassword: _oldPasswordController.text);

                           if(resp['Success']['success'] == true){
                           
                           prefs.remove('otp');

                           if(widget.comingFrom == 'login'){
                              if(user.translationLanguage!=null){
     
          Get.offAllNamed(RouteHelper.getMainScreenRoute());
       
      }else{
        Get.toNamed(RouteHelper.getSelectLanguageRoute());
      }
                           }else{
                         Navigator.pop(context);

                           }


                           }
                                }else{
                                  //iska matlab forgot passowrd hai

                                           SharedPreferences prefs = await SharedPreferences.getInstance();
                                            String email = widget.email;

      try{
      var da = jsonDecode(prefs.getString('otp')!);

      email = da['email'];

      }catch(e){}

                            //yahan se pehle password change kerwaen ge
                           var resp =    await AuthRepo(sharedPreferences: prefs).resetPassword(email: email, password: _passwordController.text);

                           if(resp['Success']['success'] == true){
                           
                           prefs.remove('otp');

                          Get.offAllNamed(RouteHelper.getSignInRoute());
                           }




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
