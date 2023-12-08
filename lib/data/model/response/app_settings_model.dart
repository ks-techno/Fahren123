import 'dart:convert';

import '../../../enums/category.dart';

class AppSettings{
  final List<PaymentMethod> paymentMethodsList;
  final String privacyPolicyUrl;
  final String test_instructions_url;
  final String? android_version;
  final String? ios_version;
  final String? forceUpdate;
  final String? showUpdate;

  AppSettings({
    required this.paymentMethodsList,
     this.privacyPolicyUrl="",
     this.test_instructions_url="",
      this.android_version,
    this.ios_version,
    this.forceUpdate,
    this.showUpdate
  });
  factory AppSettings.fromJson(Map<String,dynamic>json){
    return AppSettings(
        paymentMethodsList: List<PaymentMethod>.from(json['paymentMethod'].map((category) => PaymentMethod.fromJson(category)).toList()),
      privacyPolicyUrl: json['privacy_url']??"",
      test_instructions_url: json['test_instructions_url']??"",
         android_version: json['android_version']??"",
      ios_version: json['ios_version']??"",
      showUpdate: json['showUpdate']??"",
      forceUpdate: json['forceUpdate']??"",
    );
  }
  Map<String,dynamic>toJson(){
    Map<String,dynamic> data = {};
    data['paymentMethodsList'] = AppSettings.encodeToJson(paymentMethodsList);
    data['privacy_url'] = privacyPolicyUrl;
    return data;
  }

  static List encodeToJson(List<PaymentMethod> list) {
    List jsonList = [];
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }

}

class PaymentMethod{
  final int id;
  final String name;
  final String instructionUrl;
  final String ?paymentUrl;
  final String ?paymentSuccessUrl;
  final String ?paymentFailUrl;
  final String paymentAmount;
  final String referralAmount;

  final String currencyUnit;
  final String clientId;
  final String secretId;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.instructionUrl,
    required this.paymentUrl,
    required this.paymentSuccessUrl,
    required this.paymentFailUrl,
    required this.paymentAmount,
    required this.referralAmount,

    required this.currencyUnit,
    required this.clientId,
    required this.secretId,
  });

  factory PaymentMethod.fromJson(Map<String,dynamic>json){
    return PaymentMethod(
      id: int.parse("${json['paymentMethodId']??0}"),
      name: json['paymentMethodName']??"",
      instructionUrl: json['paymentMethodInstructionsUrl']??"",
      paymentUrl: json['paymentUrl'],
      paymentSuccessUrl: json['paymentSucessUrl'],
      paymentFailUrl: json['paymentFailUrl'],
      paymentAmount: json['amount'],
      currencyUnit: json['currencyUnit']??"",
      referralAmount: json['referral_amount']??"",
      clientId : json['client_id']??"",
      secretId : json['secret_id']??"",

    );
  }
  factory PaymentMethod.fromLocalJson(Map<String,dynamic>json){
    return PaymentMethod(
      id: int.parse("${json['paymentMethodId']??0}"),
      name: json['paymentMethodName'],
      instructionUrl: json['paymentMethodInstructionsUrl']??"",
      paymentUrl: json['paymentUrl']!=null? utf8.decode(List<int>.from(json['paymentUrl'])):null,
      paymentSuccessUrl: json['paymentSucessUrl'],
      paymentFailUrl: json['paymentFailUrl'],
      paymentAmount: json['amount'],
      currencyUnit: json['currencyUnit']??"",
      referralAmount: json['referral_amount']??'',
      clientId : json['client_id']??'',
      secretId : json['secret_id']??'',

    );
  }
  Map<String,dynamic>toJson(){
    Map<String,dynamic> data = {};
    data['paymentMethodId'] = id;
    data['paymentMethodName'] = name;
    data['paymentMethodInstructionsUrl'] = instructionUrl;
    data['paymentSucessUrl'] = paymentSuccessUrl;
    data['paymentFailUrl'] = paymentFailUrl;
    data['paymentUrl'] = paymentUrl!=null? utf8.encode(paymentUrl!):'';
    data['amount'] = paymentAmount;
    data['currencyUnit'] = currencyUnit;
    data['client_id'] = this.clientId;
    data['secret_id'] = this.secretId;
    return data;
  }

}