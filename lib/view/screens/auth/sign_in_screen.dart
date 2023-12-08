import 'package:Fahren123/enums/otp_verify_type.dart';
import 'package:Fahren123/util/app_constants.dart';
import 'package:Fahren123/util/app_strings.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/util/images.dart';
import 'package:Fahren123/util/styles.dart';
import 'package:Fahren123/view/base/custom_app_bar.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Fahren123/view/base/my_text_field.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/auth_controller.dart';
import '../../../helper/route_helper.dart';
import '../../base/custom_button.dart';
import '../forget/forget_pass_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  bool hidePassword = true;
  final FocusNode _mobileNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
   final FirebaseMessaging _fcm = FirebaseMessaging.instance;


  @override
  void initState() {
    super.initState();
    // _phoneController.text = Get.find<AuthController>().getUserNumber() ?? '';
    // _passwordController.text = Get.find<AuthController>().getUserPassword() ?? '';

    checkForOtp();
  }

  checkForOtp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('otp') != null) {
      //iska matlab isko otp wale page per le ker jana hai

      log(prefs.getString('otp').toString());

      Get.toNamed(RouteHelper.getOtpVerificationRoute(
          verificationType: OtpVerifyType.ForgetPassword));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Container(
            width: context.width,
            height: context.height,
            margin: EdgeInsets.zero,
            decoration: null,
            child: Stack(
              children: [
                Container(
                    padding: EdgeInsets.only(left: 30),
                    height: context.height * .35,
                    width: context.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Images.loginBg),
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.darken),
                            fit: BoxFit.cover)),
                    alignment: Alignment.centerLeft,
                    child: DelayedDisplay(
                      slidingBeginOffset: const Offset(0, -0.5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.loginNow,
                            style: ralewayHeading,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            AppString.welcome,
                            style: ralewaySubHeading,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            AppString.loginRequest,
                            style: ralewaySubHeading,
                          ),
                            SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: context.height * .75,
                    width: context.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.BORDER_RADIUS),
                          topRight: Radius.circular(Dimensions.BORDER_RADIUS)),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 15),
                    child:
                        GetBuilder<AuthController>(builder: (authController) {
                      return DelayedDisplay(
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            physics: BouncingScrollPhysics(),
                            children: [
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_LARGE),
                            Column(
                              children: [
                                CustomInputTextField(
                                  controller: _emailController,
                                  focusNode: _mobileNumberFocus,
                                  isPassword: false,
                                  context: context,
                                  onValueChange: (_) {
                                    setState(() {});
                                  },
                                  hintText: AppString.email,
                                  validator: (inputData) {
                                    return inputData!.isEmpty
                                        ? ErrorMessage.emailEmptyError
                                        : inputData.length > 250
                                            ? ErrorMessage
                                                .mobileNumberInvalidError
                                            : null;
                                  },
                                ),
                                const SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT),
                                CustomInputTextField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
                                  isPassword: true,
                                  onValueChange: (_) {
                                    setState(() {});
                                  },
                                  context: context,
                                  obscureText: hidePassword,
                                  maxLines: 1,
                                  hintText: AppString.password,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    icon: hidePassword
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
                                        : inputData.length <
                                                AppConstants.PASSWORD_MIN_LENGTH
                                            ? ErrorMessage
                                                .passwordMinLengthError
                                            : inputData.length > 250
                                                ? ErrorMessage
                                                    .passwordMaxLengthError
                                                : null;
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed(RouteHelper
                                            .getForgetPasswordRoute());
                                      },
                                      child: Text(
                                        AppString.isForgotPassword,
                                        style: ralewayMedium.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_LARGE),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: CustomButton(
                                height: 50,
                                fontSize: 16,
                                buttonText: AppString.signIn.tr,
                                color: _emailController.text.isNotEmpty &&
                                        _passwordController.text.isNotEmpty
                                    ? null
                                    : Colors.grey.withOpacity(0.2),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    _login(
                                      authController,
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                          ]),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppString.doNotHaveAccount,
            style: ralewayRegular,
          ),
          TextButton(
            onPressed: () {
              Get.toNamed(RouteHelper.getSignUpRoute());
            },
            child: Text(
              AppString.signUp,
              style: ralewayRegular,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login(
    AuthController authController,
  ) async {
     String? fcmToken = await _fcm.getToken();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    authController.login(email, password, fcmToken!, context);
  }
}
