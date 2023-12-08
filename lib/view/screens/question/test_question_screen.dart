import 'dart:async';
import 'dart:convert';

import 'package:Fahren123/controller/app_settings_controller.dart';
import 'package:Fahren123/controller/question_controller.dart';
import 'package:Fahren123/custom_packages/customselector/utils/enum.dart';
import 'package:Fahren123/custom_packages/customselector/utils/flutter_custom_select_item.dart';
import 'package:Fahren123/custom_packages/customselector/widget/flutter_custom_selector_sheet.dart';
import 'package:Fahren123/data/model/response/category_model.dart';
import 'package:Fahren123/data/model/response/question_model.dart';
import 'package:Fahren123/util/app_constants.dart';
import 'package:Fahren123/util/color_constants.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/view/base/custom_app_bar.dart';
import 'package:Fahren123/view/screens/privacy%20policy/instructions.dart';
import 'package:Fahren123/view/screens/question/test_result.dart';
import 'package:Fahren123/view/screens/question/widgets/question_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../util/app_strings.dart';
import '../../base/custom_button.dart';

class TestQuestionScreen extends StatefulWidget {
  
  final String testNumber;
  const TestQuestionScreen({Key? key, required this.testNumber}) : super(key: key);

  @override
  State<TestQuestionScreen> createState() => _TestQuestionScreenState();
}

class _TestQuestionScreenState extends State<TestQuestionScreen> {

  List<Question>questions = [];
  late PageController pageViewController;
  final List<Widget> _pageViewItem = <Widget>[];
  int currentIndex = 0;
  int questionNumber = 1;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List questionList = [];
    final Completer<WebViewController> _webViewController = Completer<WebViewController>();
  bool isWebViewCreating = true;

  @override
  void initState(){
    pageViewController = PageController(initialPage: currentIndex);
    Get.find<QuestionController>().fetchTestQuestions(testNumber: widget.testNumber, isFromInitState:true).then((value){
      
      questionList = value['Success']['result'];
      if(currentIndex > Get.find<QuestionController>().questions.length){
        currentIndex = 0;
      };


      setTestResults();





    });

   


    super.initState();
  }
  


  setTestResults() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('totalMarks');
    prefs.remove('testResults');

    debugPrint('ali-----------------');
    debugPrint(questionList.toString());

    if(questionList.length > 0){
       // local ko set kerna hai

       int? tm = 0;
       List result = [];

       for(var i = 0 ; i < questionList.length ; i++){
         result.add(0);
         try{
         tm = tm! + int.parse(questionList[i]['questions']['Question']['marks'].toString());

         }catch(e){}
       }
       debugPrint(tm.toString());
       prefs.setInt('totalMarks', tm!);
       prefs.setString('testResults', jsonEncode(result));

    }







  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        
        return false;
      },
      child: Scaffold(

        appBar: CustomAppBar(
          title: 'Test-'+widget.testNumber + '  Q#'+(currentIndex+1).toString(),
          leading: null,
          showLeading: true,
          onBack: (){
            Navigator.pop(context);
            // Get.back(result : {"nextCategoryIndexToView":currentIndex});
          },
         
        ),
      
        body: SafeArea(
            child: SmartRefresher(
              onRefresh: ()async{
                // await Get.find<QuestionController>().fetchQuestions(questionCategory: widget.questionCategory, isFromInitState:false);
                // if(currentIndex > Get.find<QuestionController>().questions.length){
                //   currentIndex = 0;
                //   setState((){});
                // }
                // _refreshController.refreshCompleted();
              },
              controller: _refreshController,
              child: Container(
                width: context.width,
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                margin: EdgeInsets.zero,
                child: GetBuilder<QuestionController>(builder: (questionController) {
                  return !questionController.isDataFetching
                      ? Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: questionController.questions.length,
                                scrollDirection: Axis.horizontal,
                                controller: pageViewController,
                                onPageChanged: (index){
                                  setState((){
                                    currentIndex = index;
                                  });
                                },
                                itemBuilder: (context, position) {
                                  Question question = questionController.questions[position];
                                  return QuestionItemWidget(
                                    question: question,
                                    testMode:true,
                                    questionIndex: position,
                                  );
                                }),
                          ),
                                                const SizedBox(height: 12,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if(currentIndex!= 0) 
                             Expanded(
                                child: Container(
                                
                                  child: CustomButton(
                                    fontSize: 12,
                                    height: 44,
                                    backgroundTransparent: true,
                                    buttonText: AppString.previous.tr,
                                    onPressed: (){
                                      questionController.hideOrShowAnswer(isShowAnswer: false);
                                      currentIndex--;
                                      pageViewController.jumpToPage(currentIndex);
                                      // pageViewController.animateToPage(currentIndex, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                  ),
                                ),
                              ),
                              if(currentIndex!= 0)  const SizedBox(width: 10,),

                                         Expanded(
                                child: Container(
                                  // margin: const EdgeInsets.only(left: 5),
                                  child: CustomButton(
                                    fontSize: 12,
                                    height: 44,
                                    // width: 80,
                                    backgroundTransparent: true,
                                    buttonText: AppString.next.tr,
                                    onPressed: (){

                                 

                                      questionController.hideOrShowAnswer(isShowAnswer: false);
                                      currentIndex++;
                                      pageViewController.jumpToPage(currentIndex);
                                      FocusScope.of(context).unfocus();
                                      // pageViewController.animateToPage(currentIndex, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                                  
                                    },
                                  ),
                                ),
                              ),
                       
                            


if(currentIndex==questionController.questions.length-1)  const SizedBox(width: 10,),
                              if(currentIndex==questionController.questions.length-1)

                                Expanded(
                                child: CustomButton(
                                  height: 44,
                                  fontSize: 12,
                                  buttonText: 'Submit',
                                  onPressed: (){
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> TestResult()), (route) => false);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12,),
                      
                        ],
                      )
                      : Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: context.width*.3),
                          child: LoadingAnimationWidget.flickr(
                            leftDotColor: AppColor.primaryGradiantStart,//Get.theme.primaryColor,
                            rightDotColor: AppColor.primaryGradiantEnd,
                            size: 50,
                          ),
                        ),
                      );
                }),
              ),
            )),
      ),
    );
  }
}




  
