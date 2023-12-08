import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:Fahren123/controller/app_settings_controller.dart';
import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/controller/question_controller.dart';
import 'package:Fahren123/data/model/response/app_settings_model.dart';
import 'package:Fahren123/helper/route_helper.dart';
import 'package:Fahren123/util/app_strings.dart';
import 'package:Fahren123/util/color_constants.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/util/images.dart';
import 'package:Fahren123/util/styles.dart';
import 'package:Fahren123/view/base/CustomImagePicker/Utils/utils.dart';
import 'package:Fahren123/view/base/custom_app_bar.dart';
import 'package:Fahren123/view/base/custom_snackbar.dart';
import 'package:Fahren123/view/base/my_text_field.dart';
import 'package:Fahren123/view/screens/question/widgets/pyment_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _selectedPaymentMethod =
      Get.find<AppSettingsController>().appSettings.paymentMethodsList.first;
  final Completer<WebViewController> _bankTransferViewController =
      Completer<WebViewController>();
  final FocusNode _transactionIdFocus = FocusNode();
  final TextEditingController _transactionIdController =
      TextEditingController();

  final FocusNode _couponFocus = FocusNode();
  final TextEditingController _couponController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? receiptImage;
  bool isSelected = false;
  bool couponMatched = false;
  dynamic _paymentIntent;
  String final_price = "";

  Future<void> initPaymentSheet() async {
    try {
      stripe.Stripe.publishableKey = _selectedPaymentMethod.clientId;
      stripe.Stripe.merchantIdentifier = "merchant.com.smartiimenu";

      final_price = ((double.parse(
                couponMatched
                    ? paymentPlanList[selectedPaymentPlanIndex]
                        ['referral_amount']
                    : paymentPlanList[selectedPaymentPlanIndex]['net_amount'],
              )) *
              100)
          .toStringAsFixed(2);

      if (final_price.indexOf('.') >= 0) {
        final_price = final_price.split('.')[0];
      }

      // print('fp');
      // print(final_price);

      _paymentIntent = await PaymentService().createPaymentIntent(
          final_price, 'EUR', _selectedPaymentMethod.secretId);

      // 2. initialize the payment sheet
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: _paymentIntent['client_secret'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          // merchantCountryCode: "DE",      //for striper version 3.2.0
          style: ThemeMode.dark,
          applePay: const stripe.PaymentSheetApplePay(
            merchantCountryCode: "DE",
          ), //for striper version 7.0.0
          googlePay: const stripe.PaymentSheetGooglePay(
            merchantCountryCode: "DE",
            currencyCode: "EUR",
          ), //for striper version 7.0.0
          // applePay:true, //for striper version 3.2.0
          // googlePay: true, //for striper version 3.2.0
        ),
      );

      confirmPayment();
      setState(() {});
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> confirmPayment() async {
    try {
      // 3. display the payment sheet.
      await stripe.Stripe.instance.presentPaymentSheet();

      log(_paymentIntent["id"].toString());
      var responseRetive = await PaymentService().retrivePaymentIntent(
          _paymentIntent["id"], _selectedPaymentMethod.secretId);
      if (responseRetive["status"] == "succeeded") {
         await Get.find<QuestionController>().savePaymentPlan(
                            paymentPlanList[selectedPaymentPlanIndex]
                                ['paymentPlan_id']);

         await Get.find<QuestionController>().stripPayment(

                            _paymentIntent["id"],
                            (double.parse(final_price)/100).toStringAsFixed(2));
         await Get.find<AppSettingsController>().onPaymentSuccess();

        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment succesfully completed'),
          ),
        );
      } else {
         setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed'),
          ),
        );
      }
    } on Exception catch (e) {
      if (e is stripe.StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unforeseen error: ${e}'),
          ),
        );
      }
    }
  }

  checkCoupon() {
    dynamic data = {
      // 'referral_code': 'waqasq7kns',
      'referral_code': _couponController.text.trim(),
      'user_id': Get.find<AuthController>().getLoginUserData()!.id
    };
    debugPrint("data------------------");
    debugPrint(data.toString());
    Get.find<QuestionController>().checkRefferal(data).then((value) {
      debugPrint("--------------------------------------------");
      debugPrint(value.toString());
      if (value['Success'] != null && value['Success']['success'] == true) {
        showCustomSnackBar(value['Success']['message'], isError: false);

        //matlab referral wali amount use ho gi

        setState(() {
          couponMatched = true;
        });
      } else {
        showCustomSnackBar(value['Error']['message'], isError: true);
        setState(() {
          couponMatched = false;
        });
      }
    });
  }

  showPopup() {
    Alert(
      context: context,
      // title: "Have a Promo Code?",
      // desc: "Please apply to redeem discount",

      image: Lottie.asset('assets/image/coupon.json',
          height: 200, width: 200, fit: BoxFit.cover),

      closeIcon: const Icon(Icons.close),
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Wenden Sie den Promo-Code an, um den Rabatt einzulösen',
                  textAlign: TextAlign.center,
                  style: ralewayRegular.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: CustomInputTextField(
              controller: _couponController,
              focusNode: _couponFocus,
              isPassword: false,
              noPadding: true,
              context: context,
              onValueChange: (_) {
                setState(() {});
              },
              hintText: AppString.referralCode,
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          margin: EdgeInsets.zero,
          height: 48,
          radius: BorderRadius.circular(12),
          child: Text(
            "Anwenden",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
            if (_couponController.text.isNotEmpty) {
              checkCoupon();
            }
          },
          color: Theme.of(context).primaryColor,
        ),
      ],
    ).show();
  }

  int step = 0;
  List paymentPlanList = [];

  int selectedPaymentPlanIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPaymentPlan();
  }

  fetchPaymentPlan() {
    Get.find<QuestionController>().fetchPaymentPlan().then((value) {
      if (value['Success'] != null) {
        setState(() {
          paymentPlanList = value['Success']['result'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: null,
        showLeading: true,
        title: _selectedPaymentMethod.id == 1 || step == 0
            ? AppString.purchasePlan
            : step == 1
                ? 'Bankdaten'
                : 'Quittung',
        onBack: () {
          if (_selectedPaymentMethod.id == 1 || step == 0) {
            Navigator.pop(context);
          } else {
            setState(() {
              step--;
            });
          }
        },
      ),
      body: paymentPlanList.length == 0
          ? Container()
          : Container(
              width: context.width,
              height: context.height,
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL),
              margin: EdgeInsets.zero,
              child: GetBuilder<AppSettingsController>(
                  builder: (appSettingsController) {
                List<PaymentMethod> paymentMethodList =
                    appSettingsController.appSettings.paymentMethodsList;
                int totalPaymentMethods = paymentMethodList.length;
                return ListView(
                  children: [
                    if (step == 0)
                      Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          if (paymentPlanList.length > 0)
                            Row(
                              children: [
                                Text(
                                  'Bitte wählen Sie einen Zahlungsplan aus',
                                  style: ralewayBold,
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: List.generate(
                              paymentPlanList.length,
                              (i) => InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedPaymentPlanIndex = i;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      // color: selectedPaymentPlanIndex == i? AppColor.primaryColorShade: Colors.transparent,
                                      border: Border.all(
                                          color: selectedPaymentPlanIndex == i
                                              ? Colors.black
                                              : Colors.transparent)),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Radio(
                                        value: i,
                                        groupValue: selectedPaymentPlanIndex,
                                        onChanged: (_) {
                                          setState(() {
                                            selectedPaymentPlanIndex = _ as int;
                                          });
                                        },
                                        activeColor:
                                            AppColor.primaryGradiantStart,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              paymentPlanList[i]['plan'],
                                              textAlign: TextAlign.start,
                                              style: ralewayMedium.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              '( ' +
                                                  paymentPlanList[i]['notes'] +
                                                  ' )',
                                              textAlign: TextAlign.start,
                                              style: ralewayMedium.copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          if (paymentPlanList[i]
                                                  ['original_price'] !=
                                              null)
                                            Text(
                                              paymentPlanList[i]
                                                  ['original_price'],
                                              textAlign: TextAlign.center,
                                              style: ralewayMedium.copyWith(
                                                fontSize: 12,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationThickness: 1.5,
                                                // decorationColor: Colors.red÷,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          Text(
                                            ("${couponMatched ? paymentPlanList[i]['referral_amount'] : paymentPlanList[i]['net_amount']} ${_selectedPaymentMethod.currencyUnit} / "),
                                            textAlign: TextAlign.center,
                                            style: ralewayMedium.copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            paymentPlanList[i]['short_code'],
                                            textAlign: TextAlign.center,
                                            style: ralewayMedium.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (step == 0)
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  // height: 70,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      // color: AppColor.primaryColorShade,

                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.discount_outlined,
                                        color: AppColor.primaryGradiantStart,
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: Text(
                                            couponMatched
                                                ? 'Rabatt in Anspruch genommen'
                                                : 'Wenden Sie einen Promo-Code an',
                                            style: ralewayRegular.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            )),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (!couponMatched) {
                                            showPopup();
                                          }
                                        },
                                        child: Text(
                                            couponMatched
                                                ? 'Angewandt'
                                                : 'Anwenden',
                                            textAlign: TextAlign.center,
                                            style: ralewayRegular.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  AppColor.primaryGradiantStart,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                        ],
                      ),
                    if (step == 0)
                      SizedBox(
                        height: 160,
                        child: Center(
                          child: ListView.builder(
                            itemCount: totalPaymentMethods,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext listContext, int index) {
                              PaymentMethod paymentMethod =
                                  paymentMethodList[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                height: 44,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor),
                                  color: _selectedPaymentMethod == paymentMethod
                                      ? AppColor.primaryGradiantStart
                                          .withOpacity(0.1)
                                      : Colors.transparent,
                                  // color: Colors.transparent
                                ),
                                child: MaterialButton(
                                  onPressed: () {
                                    _selectedPaymentMethod = paymentMethod;
                                    _transactionIdController.clear();
                                    receiptImage = null;
                                    setState(() {});
                                  },
                                  height: 44,
                                  // minWidth: width,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.BORDER_RADIUS),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 32,
                                        width: 32,
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Image.asset(
                                          paymentMethod.id == 1
                                              ? Images.paypal
                                              : paymentMethod.id == 2
                                                  ? Images.bank
                                                  : Images.stripe,
                                          fit: BoxFit.contain,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Text(paymentMethod.name,
                                          textAlign: TextAlign.center,
                                          style: ralewayBold.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_DEFAULT,
                    ),
                    _selectedPaymentMethod.id == 2

                        /// Bank Transfer Payment
                        ? Column(
                            children: [
                              if (step == 1)
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: WebView(
                                    key: Key(_selectedPaymentMethod.name),
                                    backgroundColor: Colors.white,
                                    initialUrl:
                                        _selectedPaymentMethod.instructionUrl,
                                    javascriptMode: JavascriptMode.unrestricted,
                                    zoomEnabled: true,
                                    onWebViewCreated:
                                        (WebViewController webViewController) {
                                      if (!_bankTransferViewController
                                          .isCompleted) {
                                        _bankTransferViewController
                                            .complete(webViewController);
                                      }
                                    },
                                  ),
                                ),
                              if (step == 2)
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),
                              if (step == 2)
                                Row(
                                  children: [
                                    Text(
                                      AppString.accountholder,
                                      style: ralewayBold,
                                    ),
                                  ],
                                ),
                              if (step == 2)
                                SizedBox(
                                  height: 8,
                                ),
                              if (step == 2)
                                Form(
                                  key: _formKey,
                                  child: CustomInputTextField(
                                    controller: _transactionIdController,
                                    focusNode: _transactionIdFocus,
                                    isPassword: false,
                                    noPadding: true,
                                    context: context,
                                    hintText: AppString.accountholder,
                                    // validator: (inputData) {
                                    //   return inputData!.isEmpty
                                    //       ? ErrorMessage.transactionIdEmptyError
                                    //       : inputData.length>250
                                    //       ? ErrorMessage.transactionIdInvalidError
                                    //       : null;
                                    // },
                                  ),
                                ),
                              if (step == 2)
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_SMALL,
                                ),
                              if (step == 2)
                                Row(
                                  children: [
                                    Text(
                                      'Überweisungsbeleg',
                                      style: ralewayBold,
                                    ),
                                  ],
                                ),
                              SizedBox(
                                height: 8,
                              ),
                              if (step == 2)
                                InkWell(
                                  onTap: () async {
                                    var isPermissionsGranted =
                                        await Permission.mediaLibrary.request();
                                    print(isPermissionsGranted);
                                    File? image = await getImage();
                                    if (image != null) {
                                      receiptImage = image;
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    height: context.height * .20,
                                    width: context.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: receiptImage != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.file(
                                              receiptImage!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: context.height * .07,
                                                  width: context.width * .12,
                                                  child: Image.asset(
                                                    Images.addImage,
                                                    fit: BoxFit.contain,
                                                    color: Theme.of(context)
                                                        .primaryColorLight
                                                        .withOpacity(.5),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: Dimensions
                                                      .PADDING_SIZE_SMALL,
                                                ),
                                                Text(
                                                  "Bitte Überweisungsbeleg hinzufügen",
                                                  style:
                                                      ralewayRegular.copyWith(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .primaryColorLight
                                                        .withOpacity(.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                            ],
                          )
                        : const SizedBox(),
                    if (step == 2)
                      SizedBox(
                        height: 20,
                      ),
                    if (_selectedPaymentMethod.id == 1 ||
                        _selectedPaymentMethod.id == 3 ||
                        step == 2)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected = !isSelected;
                          });
                        },
                        child: Row(
                          children: [
                            // InkWell(
                            //   onTap: (){
                            //       setState((){
                            //         isSelected = !isSelected;
                            //       });
                            //   },
                            //   child: Container(
                            //     padding: const EdgeInsets.only(right: 10,top: 5,bottom: 5),
                            //     child: Container(
                            //       height: 15,
                            //       width: 15,
                            //       padding: const EdgeInsets.all(5),
                            //       decoration: BoxDecoration(
                            //         gradient: isSelected? AppColor.appMainGradient : null,
                            //         color: isSelected? null :Theme.of(context).primaryColorDark,
                            //         border: Border.all(color: Colors.black,),
                            //         shape: BoxShape.circle,
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected = !isSelected;
                                });
                              },
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                ),
                                child: Center(
                                  child: Icon(Icons.done_outlined,
                                      size: 20, color: Colors.white),
                                ),
                              ),
                            ),

                            SizedBox(
                              width: 10,
                            ),
                            RichText(
                                text: TextSpan(
                                    style: ralewayRegular.copyWith(
                                      fontSize: 14,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                    children: <TextSpan>[
                                  TextSpan(
                                    text: "Ich akzeptiere das",
                                    style: ralewayRegular.copyWith(
                                      fontSize: 14,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                  ),
                                  TextSpan(
                                      text: ' Geschäftsbedingungen',
                                      style: ralewayRegular.copyWith(
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.toNamed(RouteHelper
                                              .getPrivacyPolicyRoute());
                                        }),
                                ])),
                          ],
                        ),
                      )
                  ],
                );
              }),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
          padding: const EdgeInsets.all(0),
          height: 44,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS),
              border: Border.all(color: Theme.of(context).primaryColor),
              color: Colors.transparent),
          child: MaterialButton(
            onPressed: () async {
              if (_selectedPaymentMethod.id == 1) {
                if (isSelected) {
                  PaymentMethod paymentMethod = PaymentMethod(
                    id: _selectedPaymentMethod.id,
                    name: _selectedPaymentMethod.name,
                    instructionUrl: _selectedPaymentMethod.instructionUrl,
                    paymentUrl:
                        "${_selectedPaymentMethod.paymentUrl}?amount=${couponMatched ? paymentPlanList[selectedPaymentPlanIndex]['referral_amount'] : paymentPlanList[selectedPaymentPlanIndex]['net_amount']}&user_id=${Get.find<AuthController>().getLoginUserData()!.id}",
                    paymentSuccessUrl: _selectedPaymentMethod.paymentSuccessUrl,
                    paymentFailUrl: _selectedPaymentMethod.paymentFailUrl,
                    paymentAmount: couponMatched
                        ? paymentPlanList[selectedPaymentPlanIndex]
                            ['referral_amount']
                        : paymentPlanList[selectedPaymentPlanIndex]
                            ['net_amount'],
                    referralAmount: paymentPlanList[selectedPaymentPlanIndex]
                        ['referral_amount'],
                    currencyUnit: _selectedPaymentMethod.currencyUnit,
                    clientId: _selectedPaymentMethod.clientId,
                    secretId: _selectedPaymentMethod.secretId,
                  );
                  dynamic result = await Get.toNamed(
                          RouteHelper.getDigitalPaymentRoute(
                              paymentMethod: paymentMethod)) ??
                      {"success": false};
                  if (result['success']) {
                    await Future.delayed(const Duration(milliseconds: 100));

                    //save plan
                    await Get.find<QuestionController>().savePaymentPlan(
                        paymentPlanList[selectedPaymentPlanIndex]
                            ['paymentPlan_id']);
                    await Get.find<AppSettingsController>().onPaymentSuccess();
                  }
                } else {
                  showCustomSnackBar(
                    "Akzeptieren Sie die Nutzungsbedingungen, um fortzufahren",
                  );
                }
              } else if (_selectedPaymentMethod.id == 2) {
                if (step == 2) {
                  if (receiptImage != null) {
                    if (isSelected) {
                      Get.find<AppSettingsController>()
                          .purchasePlanViaBankTransfer(
                        transactionId: _transactionIdController.text.trim(),
                        amount: couponMatched
                            ? paymentPlanList[selectedPaymentPlanIndex]
                                ['referral_amount']
                            : paymentPlanList[selectedPaymentPlanIndex]
                                ['net_amount'],
                        imagePath: receiptImage!.path,
                        context: context,
                      );
                    } else {
                      showCustomSnackBar(
                        "Akzeptieren Sie die Nutzungsbedingungen, um fortzufahren",
                      );
                    }
                  } else {
                    showCustomSnackBar("Bitte Belegbild auswählen");
                  }
                } else {
                  setState(() {
                    step++;
                  });
                }
              } else if (_selectedPaymentMethod.id == 3) {
                if (isSelected) {
                  log("${_selectedPaymentMethod.secretId}      ...........secret id");
                  log("${_selectedPaymentMethod.clientId}      ...........client id");
                  initPaymentSheet();
                } else {
                  showCustomSnackBar(
                    "Akzeptieren Sie die Nutzungsbedingungen, um fortzufahren",
                  );
                }
              }
            },
            height: 44,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS),
            ),
            child: Text(
                // _selectedPaymentMethod.id == 1
                //     ? "Bezahlen"
                //     :
                _selectedPaymentMethod.id == 2 ? "Weiter" : "Bezahlen",
                textAlign: TextAlign.center,
                style: ralewayBold.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeDefault,
                )),
          ),
        ),
      ),
    );
  }
}
