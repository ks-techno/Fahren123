import 'dart:developer';

import 'package:Fahren123/data/api/Api_Handler/api_error_response.dart';
import 'package:Fahren123/data/model/response/question_model.dart';
import 'package:Fahren123/data/repository/question_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as GetX;

import '../data/model/response/category_model.dart';

class QuestionController extends GetX.GetxController implements GetX.GetxService {
  final QuestionRepo questionRepo;
  QuestionController({required this.questionRepo});
  bool _isShowAnswer = false;
  bool _isShowTranslation = true;

  bool isDataFetching = false;
  List<Question>_questionsList = <Question>[];

  bool get isShowAnswer => _isShowAnswer;
  bool get isShowTranslation => _isShowTranslation;
  List<Question> get questions => _questionsList;


  Future<Map<String,dynamic>> fetchQuestions({required QuestionCategory questionCategory, bool isFromInitState=false}) async {
    isDataFetching = true;
    if(!isFromInitState){
      try{
        update();
      }catch(e){
        debugPrint("Exception:->>> $e");
      }
    }

    Map<String,dynamic> response = await questionRepo.getQuestion(questionCategory: questionCategory);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      dynamic result =  response[API_RESPONSE.SUCCESS]['result'];
      _questionsList = List<Question>.from(result.map((question) => Question.fromJson(question)).toList());
      print("_questionsList length:-> ${_questionsList.length}");
    }
    isDataFetching = false;
    update();
    return response;
  }
  Future<Map<String,dynamic>> fetchTestQuestions({required String testNumber, bool isFromInitState=false}) async {
    isDataFetching = true;
    // if(!isFromInitState){
    //   try{
    //     update();
    //   }catch(e){
    //     debugPrint("Exception:->>> $e");
    //   }
    // }

    Map<String,dynamic> response = await questionRepo.getTestQuestion(testNumber: testNumber);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      dynamic result =  response[API_RESPONSE.SUCCESS]['result'];
      _questionsList = List<Question>.from(result.map((question) => Question.fromJson(question)).toList());
      print("_questionsList length:-> ${_questionsList.length}");
    }
    isDataFetching = false;
    update();
    return response;
  }
  Future<Map<String,dynamic>> fetchTrialQuestions({bool isFromInitState=false}) async {
    isDataFetching = true;
    if(!isFromInitState){
      try{
        update();
      }catch(e){
        debugPrint("Exception:->>> $e");
      }
    }

    Map<String,dynamic> response = await questionRepo.getTrialQuestion();
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      dynamic result =  response[API_RESPONSE.SUCCESS]['result'];
      _questionsList = List<Question>.from(result.map((question) => Question.fromJson(question)).toList());
      print("_questionsList length:-> ${_questionsList.length}");
    }
    isDataFetching = false;
    update();
    return response;
  }

     Future<Map<String,dynamic>> checkRefferal(data) async {
   

    Map<String,dynamic> response = await questionRepo.checkReferral(data);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      dynamic result =  response[API_RESPONSE.SUCCESS]['result'];
     
    }
   
    return response;
  }

  void hideOrShowAnswer({bool ?isShowAnswer}){
    _isShowAnswer = isShowAnswer ?? !_isShowAnswer;
   
    update();
  }
  void hideOrShowTranslation({bool ?isShowTranslation}){
    debugPrint("before _isShowTranslation:-> $_isShowTranslation");
    _isShowTranslation = isShowTranslation ?? !_isShowTranslation;
    debugPrint("applying _isShowTranslation:-> $_isShowTranslation");
    update();
  }

  Color getQuestionSelectionColor({required TranslationLanguage option, required BuildContext context, required List<TranslationLanguage>selectedAnswersList, bool isBorder=false}){

    Color questionHighLightColor;
    if(_isShowAnswer && option.isCorrectAnswer && isBorder){
   
       questionHighLightColor = Colors.green;//Theme.of(context).primaryColor;
    }else if(_isShowAnswer && !option.isCorrectAnswer && isBorder){
   
       questionHighLightColor = Colors.red;//Theme.of(context).primaryColor;
    }
    else if(selectedAnswersList.any((selectedOption) => selectedOption.primary==option.primary)){
      if(option.isCorrectAnswer){
        questionHighLightColor = Theme.of(context).primaryColor;
      }else{
        questionHighLightColor = Theme.of(context).errorColor;
      }
    }else{
      questionHighLightColor = Colors.grey.shade300;
    }
    return questionHighLightColor;
  }

  bool checkIfOptionExists({required TranslationLanguage option,required List<TranslationLanguage>selectionList}){
    bool isOptionExists = false;
    for (TranslationLanguage answer in selectionList) {
      if(answer.primary==option.primary){
        isOptionExists = true;
        break;
      }
    }
    return isOptionExists;
  }

   Future<Map<String,dynamic>> fetchPaymentPlan() async {
    isDataFetching = true;
   

    Map<String,dynamic> response = await questionRepo.getPaymentPlan();
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      dynamic result =  response[API_RESPONSE.SUCCESS]['result'];
    
    }
    isDataFetching = false;
    update();
    return response;
  }

    Future<Map<String,dynamic>> savePaymentPlan(planId) async {
    isDataFetching = true;
   

    Map<String,dynamic> response = await questionRepo.savePaymentPlan(planId);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      dynamic result =  response[API_RESPONSE.SUCCESS]['result'];
    
    }
    isDataFetching = false;
    update();
    return response;
  }

  Future<Map<String,dynamic>> stripPayment(transectionId,amount) async {
    isDataFetching = true;
   

    Map<String,dynamic> response = await questionRepo.stripePayment(transectionId,amount);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      dynamic result =  response[API_RESPONSE.SUCCESS]['result'];

    
    }
    isDataFetching = false;
    update();
    return response;
  }
   
   Future<Map<String,dynamic>> readNotification(String id) async {
   

    Map<String,dynamic> response = await questionRepo.readNotification(id);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      dynamic result =  response[API_RESPONSE.SUCCESS]['result'];
     
    }
   
    return response;
  }
    Future<Map<String,dynamic>> fetchPerformance() async {
   

    Map<String,dynamic> response = await questionRepo.getPerformance();
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      dynamic result =  response[API_RESPONSE.SUCCESS]['result'];
     
    }
   
    return response;
  }

     Future<Map<String,dynamic>> fetchNotification() async {
   

    Map<String,dynamic> response = await questionRepo.getNotification();
    


    if(response.containsKey(API_RESPONSE.SUCCESS)){
      dynamic result =  response[API_RESPONSE.SUCCESS]['result'];
     
    }
   
    return response;
  }

    Future<Map<String,dynamic>> savePerformance(data) async {
   

    Map<String,dynamic> response = await questionRepo.savePerformance(data);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      dynamic result =  response[API_RESPONSE.SUCCESS]['result'];
     
    }
   
    return response;
  }

  

}