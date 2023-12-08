import 'package:Fahren123/data/model/response/language_model.dart';
import 'package:Fahren123/data/model/response/question_model.dart';

class UserInfoModel {
  int id;
  TranslationLanguageModel ?translationLanguage;
  String name;
  String email;
  String phone;
  String tokenType;
  String ?expireAt;
  String ?paymentStatus;
  String accessToken;
  
  // bool isVerified;
  // int isDeleted;

  UserInfoModel({
    required this.id,
    required this.translationLanguage,
    required this.name,
    required this.paymentStatus,
    required this.email,
    required this.phone,
    required this.tokenType,
    required this.expireAt,
    required this.accessToken,
    
    // required this.isVerified,
    // required this.isDeleted,
  });
//
  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
    id : int.parse("${json['id']}"),
    translationLanguage: json['language']!=null? TranslationLanguageModel.fromJson(json):null,
    name : json['name'],
    paymentStatus: json['payment_status'],
    email : json['email'],
    phone : json['phone'],
    tokenType : "Basic",
    expireAt : null,
    accessToken : json['token'],
  
    // isVerified : json['email_verified_at']!= null,
    // isDeleted : json['is_deleted'],
    );
  }
//
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['token_type'] = tokenType;
    data['expires_at'] = expireAt;
    data['token'] = accessToken;
   
    data['payment_status'] = paymentStatus;
    // data['email_verified_at'] = isVerified?"05-10-2022":null;
    // data['is_deleted'] = isDeleted;
    if(translationLanguage!=null){
      data.addAll(translationLanguage!.toJson());
    }
    return data;
  }
}
