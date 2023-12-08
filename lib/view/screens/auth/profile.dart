import 'dart:convert';

import 'package:Fahren123/data/repository/auth_repo.dart';
import 'package:Fahren123/enums/gender.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/util/styles.dart';
import 'package:Fahren123/view/base/custom_app_bar.dart';
import 'package:Fahren123/view/base/custom_snackbar.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/auth_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../util/app_constants.dart';
import '../../../util/app_strings.dart';
import '../../base/custom_button.dart';
import '../../base/my_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _mobileNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  Gender userGender = Gender.Male;
  bool hidePassword = true;
  bool hideConfirmPassword=true;
  final _formKey = GlobalKey<FormState>();
  // String ?selectedLanguage;

  bool terms = false;


  @override
  void initState() {
    super.initState();

    getUser();
  }

  getUser() async {
    SharedPreferences da = await SharedPreferences.getInstance();

    try{
var resp = await AuthRepo(sharedPreferences: da).getUserById(
        id: Get.find<AuthController>().getLoginUserData()!.id.toString(), loader: true);

    debugPrint('ali----------------');
    debugPrint(resp.toString());

    if (resp['Success']['success'] == true) {

      
      
      _nameController.text = resp['Success']['result']['name'];
      _mobileNumberController.text = resp['Success']['result']['phone'];
      _emailController.text = resp['Success']['result']['email'];
      userGender = resp['Success']['result']['gender'] == 'male' ? Gender.Male:resp['Success']['result']['gender'] == 'female' ?  Gender.Female: Gender.Other;
    
    try{

      selectedPlan = resp['Success']['result']['payment_plan'] ;
    }catch(e){}

    setState(() {
      
    });
    
    }
    }catch(e){}

    
  }

 String selectedPlan = '';

  ListTile getItem(String title, String subtitle, IconData icon ){
    return ListTile(
      dense: true,
      
      title: Text(title, style: ralewayMedium,),
      leading: Container(
        height: 40,
        width: 40,
        // color: Colors.red,
        child: Icon(icon)),
      subtitle: Text(subtitle, style: ralewayRegular,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: const CustomAppBar(title: "Profile", leading: null,showLeading: true,),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Container(
              width: context.width,
              height: context.height,
              margin: EdgeInsets.zero,
              decoration: null,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: context.height,
                  width: context.width,
                  decoration:  BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.BORDER_RADIUS),topRight: Radius.circular(Dimensions.BORDER_RADIUS)),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 15),
                  child: GetBuilder<AuthController>(builder: (authController) {
                    return DelayedDisplay(
                      child: Form(
                        key: _formKey,
                        child: Column(
                        
                          children: [
                      
                            const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                            const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                            const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                             
                      
                            getItem('Name', _nameController.text, Icons.person),
                            getItem('Phone Number', _mobileNumberController.text, Icons.phone),
                            getItem('Email', _emailController.text, Icons.email_rounded),
                            getItem('Gender', userGender == Gender.Male? 'Male': userGender == Gender.Female? 'Female':'Other', Icons.male ),
                            if(selectedPlan != '') getItem('Payment Plan', selectedPlan,Icons.subscriptions_rounded ),
                          
 
                          ],
                        ),
                      ),
                    );
                  })
                ),
              ),
            ),
          ),
        ),
      ),
    
    );
  }

  void _register(AuthController authController) {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword=_confirmPasswordController.text.trim();
    String phoneNumber = _mobileNumberController.text.trim();
    if (password != confirmPassword) {
      showCustomSnackBar(ErrorMessage.confirmPasswordError.tr);
    } else {
      authController.signUp(name: name,email: email,password: password,phoneNumber:phoneNumber,gender: userGender.name);
    }
  }
}
