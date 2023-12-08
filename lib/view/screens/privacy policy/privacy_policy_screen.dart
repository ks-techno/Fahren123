import 'dart:async';

import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/helper/route_helper.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/view/base/custom_app_bar.dart';
import 'package:Fahren123/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../controller/app_settings_controller.dart';
import '../../../util/app_constants.dart';
import '../../../util/app_strings.dart';
import '../../../util/styles.dart';
import '../../base/my_text_field.dart';

class PrivacyPolicyScreen extends StatefulWidget {

  const PrivacyPolicyScreen({Key? key,}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final Completer<WebViewController> _bankTransferViewController = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const CustomAppBar(title: AppString.privacyPolicy, leading: null,showLeading: true,),
      body: SafeArea(
          child: Container(
            width: context.width ,
            height: context.height,
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            margin: EdgeInsets.zero,
            child: GetBuilder<AppSettingsController>(builder: (appSettingsController) {
              print("appSettingsController.appSettings.paymentMethodsList.last.privacyPolicyUrl...>${appSettingsController.appSettings.privacyPolicyUrl}");
              return WebView(
                key: Key(appSettingsController.appSettings.privacyPolicyUrl),
                backgroundColor: Colors.white,
                onWebViewCreated: (controller){

                },
                initialUrl: appSettingsController.appSettings.privacyPolicyUrl,
                javascriptMode: JavascriptMode.unrestricted,
                zoomEnabled: true,
              );
            }),
          )),
    );
  }
}
