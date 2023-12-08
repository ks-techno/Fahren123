import 'dart:async';

import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/helper/route_helper.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/view/base/custom_app_bar.dart';
import 'package:Fahren123/view/base/custom_button.dart';
import 'package:Fahren123/view/screens/question/test_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../controller/app_settings_controller.dart';
import '../../../util/app_constants.dart';
import '../../../util/app_strings.dart';
import '../../../util/styles.dart';
import '../../base/my_text_field.dart';

class InstructionScreen extends StatefulWidget {
final String testNumber;
   const InstructionScreen({Key? key, required this.testNumber}) : super(key: key);

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  final Completer<WebViewController> _bankTransferViewController = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: const CustomAppBar(title: 'Instructions', leading: null,showLeading: true,),
      body: SafeArea(
          child: Container(
            width: context.width ,
            height: context.height,
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            margin: EdgeInsets.zero,
            child: GetBuilder<AppSettingsController>(builder: (appSettingsController) {
              return WebView(
                key: Key(appSettingsController.appSettings.test_instructions_url),
                backgroundColor: Colors.white,
                onWebViewCreated: (controller){
    
                },
                initialUrl: appSettingsController.appSettings.test_instructions_url,
                javascriptMode: JavascriptMode.unrestricted,
                zoomEnabled: true,
              );
            }),
          )),
    bottomNavigationBar:         Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      // color: Colors.red,
      child: CustomButton(
        fontSize: 12,
        height: 44,
        // width: 80,
        backgroundTransparent: true,
        buttonText: AppString.next.tr,
        onPressed: (){

                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  TestQuestionScreen(testNumber: widget.testNumber,)));


          
        },
      ),
    ),
    );
  }
}
