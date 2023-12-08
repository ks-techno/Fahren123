import 'dart:async';
import 'dart:convert';

import 'package:Fahren123/controller/question_controller.dart';
import 'package:Fahren123/custom_packages/customselector/utils/enum.dart';
import 'package:Fahren123/custom_packages/customselector/utils/flutter_custom_select_item.dart';
import 'package:Fahren123/custom_packages/customselector/widget/flutter_custom_selector_sheet.dart';
import 'package:Fahren123/data/model/response/category_model.dart';
import 'package:Fahren123/data/model/response/question_model.dart';
import 'package:Fahren123/helper/route_helper.dart';
import 'package:Fahren123/util/app_constants.dart';
import 'package:Fahren123/util/color_constants.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/util/styles.dart';
import 'package:Fahren123/view/base/custom_app_bar.dart';
import 'package:Fahren123/view/screens/question/widgets/question_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/app_strings.dart';
import '../../base/custom_button.dart';

class TestResult extends StatefulWidget {
  // final dynamic questionCategory;
  // const TestResult({Key? key, required this.questionCategory}) : super(key: key);

  @override
  State<TestResult> createState() => _TestResultState();
}

class _TestResultState extends State<TestResult> {

 
  final RefreshController _refreshController = RefreshController(initialRefresh: false);


  int totalMarks = 0;
  int obtainedMarks = 0;

  bool loading = true;

  @override
  void initState(){

    checkResults();

    Timer( Duration(seconds: 2) ,(){

setState(() {
  loading = false;
});
    });
   
    super.initState();
  }

  checkResults() async {
   
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try{
      totalMarks = prefs.getInt('totalMarks')!;
      List result = jsonDecode(prefs.getString('testResults')!);
      debugPrint(result.toString());
for (var i = 0; i < result.length; i++) {
      obtainedMarks += int.parse(result[i].toString());
  
}
    }catch(e){}


setState(() {
  
});


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        
        return false;
      },
      child: Scaffold(

        appBar: CustomAppBar(
          title: 'Test Results',
          leading: null,
          showLeading: false,
          
         
        ),
        body: SafeArea(
            child: loading? Center(
                        child: SizedBox(
                          height: context.height*.8,
                          child: LoadingAnimationWidget.flickr(
                            leftDotColor: AppColor.primaryGradiantStart,//Get.theme.primaryColor,
                            rightDotColor: AppColor.primaryGradiantEnd,
                            size: 50,
                          ),
                        ),
                      ): Container(
              width: context.width,
              height: context.height,
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Container(
                          margin: EdgeInsets.only(right: (obtainedMarks/totalMarks) < 0.5 ?0:40),
                          // color: Colors.red,
                          child: Lottie.asset((obtainedMarks/totalMarks) < 0.5 ? 'assets/image/failed.json': 'assets/image/congo.json',
                          height: 300,
                          width: 300,
                          repeat: false,
                          
                          fit: BoxFit.cover
                          ),
                        ),
                        
                         const SizedBox(height: 20,),
                         Text(obtainedMarks.toString()+' / '+totalMarks.toString(),
                        style: ralewayRegular.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                    ),
                         ),
                         const SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           Expanded(
                              child: CustomButton(
                                height: 44,
                                fontSize: 12,
                                buttonText: 'Go To Home',
                                onPressed: () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.remove('totalMarks');
    prefs.remove('testResults');

                                 Get.offAllNamed(RouteHelper.getMainScreenRoute());
                                },
                              ),
                            ),

      ],
                        ),
                      
                    
                      ],
                    )
                    
              
            )),
      ),
    );
  }
}
