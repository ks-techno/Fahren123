import 'dart:async';
import 'package:Fahren123/data/model/response/app_settings_model.dart';
import 'package:Fahren123/view/base/custom_app_bar.dart';
import 'package:Fahren123/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DigitalPaymentGatewayScreen extends StatefulWidget {
  final PaymentMethod digitalPayment;
  const DigitalPaymentGatewayScreen({Key? key, required this.digitalPayment}) : super(key: key);

  @override
  State<DigitalPaymentGatewayScreen> createState() => _DigitalPaymentGatewayScreenState();
}
class _DigitalPaymentGatewayScreenState extends State<DigitalPaymentGatewayScreen> {
  final Completer<WebViewController> _webViewController = Completer<WebViewController>();
  bool isWebViewCreating = true;
  @override
  Widget build(BuildContext context) {
    debugPrint("payment url:-> ${widget.digitalPayment.paymentUrl}");
    return Scaffold(
      appBar: CustomAppBar(
        leading: null,
        showLeading: true,
        title: "${widget.digitalPayment.name} payment",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              WebView(
                initialUrl: widget.digitalPayment.paymentUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _webViewController.complete(webViewController);
                },
                onPageFinished: (String url){
                  debugPrint("url:-> $url");
                  if(mounted){
                    if(url.toLowerCase().contains(widget.digitalPayment.paymentSuccessUrl!.toLowerCase())){
                      /// Payment Successful
                      Get.back(result:{'success': true});
                    }else if(url.toLowerCase().contains(widget.digitalPayment.paymentFailUrl!.toLowerCase())){
                      /// Payment Failed
                      Get.back(result:{'success': false});
                    }
                  }
                },
                zoomEnabled: false,
                onPageStarted: (String url){
                  debugPrint("url:-> $url");
                  if(url.toLowerCase().contains(widget.digitalPayment.paymentSuccessUrl!.toLowerCase())){
                    /// Payment Successful
                    // showCustomSnackBar("Payment done successfully",isError:false);
                    Get.back(result:{'success': true});

                  }else if(url.toLowerCase().contains(widget.digitalPayment.paymentFailUrl!.toLowerCase())){
                    /// Payment Failed
                    showCustomSnackBar("Payment failed",isError:false);
                    Get.back(result:{'success': false});
                  }
                },
                onWebResourceError: (error){
                  debugPrint("onWebResourceError:-> $error");
                },
                onProgress: (int? progressValue ){
                  if((progressValue??0)>99){
                    setState(() {
                      isWebViewCreating = false;
                    });
                  }
                },
              ),
           
              isWebViewCreating
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}