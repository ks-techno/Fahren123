import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;


class PaymentService {
  var client = http.Client();
  var dio = new Dio();

  static String apiBase = 'https://api.stripe.com/v1';
  

//payment intent for connected account
  Future createPaymentIntent(String amount, String currency, String secretKey ) async {

     String secret = secretKey;
   Map<String, String> headers = {
    'Authorization': 'Bearer ${secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
    try {
      Map<String, dynamic> body = {
        
      };
     
        body = {
          "amount": amount,
        "currency": currency,
        "payment_method_types[]": 'card'
        };
      
      var response = await http.post(Uri.parse(apiBase + '/payment_intents'),
          body: body, headers: headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('error charging user: ${err.toString()}');
    }
    return null;
  }

  Future confirmPaymentIntent(String pi, String secretKey) async {
      String secret = secretKey;
   Map<String, String> headers = {
    'Authorization': 'Bearer ${secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
    try {
      Map<String, dynamic> body = {};
      var response = await http.post(
          Uri.parse(apiBase + '/payment_intents/${pi}/confirm'),
          body: body,
          headers: headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('error charging user: ${err.toString()}');
    }
    return null;
  }

Future retrivePaymentIntent(String pi, String secretKey) async {
      String secret = secretKey;
      Map<String, String> headers = {
    'Authorization': 'Bearer ${secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
    try {
      Map<String, dynamic> body = {};
      var response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents/$pi"),
          body: body, headers: headers);
      return jsonDecode(response.body);
    } catch (err) {
      print( '${err.toString()}');
    }
    return null;
  }

  
}
