import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/controller/question_controller.dart';
import 'package:Fahren123/custom_packages/customselector/utils/enum.dart';
import 'package:Fahren123/custom_packages/customselector/utils/flutter_custom_select_item.dart';
import 'package:Fahren123/custom_packages/customselector/widget/flutter_custom_selector_sheet.dart';
import 'package:Fahren123/data/model/response/category_model.dart';
import 'package:Fahren123/data/model/response/question_model.dart';
import 'package:Fahren123/enums/category.dart';
import 'package:Fahren123/helper/route_helper.dart';
import 'package:Fahren123/util/app_constants.dart';
import 'package:Fahren123/util/color_constants.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/util/images.dart';
import 'package:Fahren123/util/styles.dart';
import 'package:Fahren123/view/base/custom_app_bar.dart';
import 'package:Fahren123/view/base/custom_snackbar.dart';
import 'package:Fahren123/view/screens/home/main_screen.dart';
import 'package:Fahren123/view/screens/question/widgets/question_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/app_strings.dart';
import '../../base/custom_button.dart';

class TrialQuestionScreen extends StatefulWidget {
  const TrialQuestionScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TrialQuestionScreen> createState() => _TrialQuestionScreenState();
}

class _TrialQuestionScreenState extends State<TrialQuestionScreen> {
  List<Question> questions = [];
  late PageController pageViewController;
  final List<Widget> _pageViewItem = <Widget>[];
  int currentIndex = 0;
  int questionNumber = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    pageViewController = PageController(initialPage: currentIndex);
    getQuestions();
    super.initState();
  }

  getQuestions(){
Get.find<QuestionController>()
        .fetchTrialQuestions(isFromInitState: true)
        .then((value) {
      if (currentIndex > Get.find<QuestionController>().questions.length) {
        currentIndex = 0;
      }
     
    });
  }

  String id = '0';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: {"nextCategoryIndexToView": currentIndex});
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Text(
                       'Fahren123 App',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: ralewayMedium.copyWith(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Testfragen Nr.' +
                (currentIndex + 1).toString(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: ralewayMedium.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                          
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
         toolbarHeight: 80,
      elevation: 8,
      backgroundColor: Colors.white,
      centerTitle: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16))),
          leading: Container(
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                zoomDrawerController.toggle?.call();
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  Images.menu,
                  width: 22,
                  height: 22,
                ),
              ),
            ),
          ),
          
        
          actions: [
           IconButton(
              onPressed: () async {
                Map<String, List<String>?> result =
                    await CustomBottomSheetSelector<String>().customBottomSheet(
                  buildContext: context,
                  selectedItemColor: Theme.of(context).primaryColorLight,
                  initialSelection: [
                    Get.find<QuestionController>().isShowTranslation
                       ? "Übersetzung ausblenden"
                          : "Übersetzung zeigen"
                  ],
                  buttonType: CustomDropdownButtonType.singleSelect,
                  headerName: "Einstellungen",
                  dropdownItems: [
                    CustomMultiSelectDropdownItem(
                        Get.find<QuestionController>().isShowTranslation
                           ? "Übersetzung ausblenden"
                          : "Übersetzung zeigen",
                        Get.find<QuestionController>().isShowTranslation
                            ? "Übersetzung ausblenden"
                          : "Übersetzung zeigen"),
                              CustomMultiSelectDropdownItem('1', AppConstants.learnInEnglish? 'Auf Deutsch lernen': 'Learn in English')
                  ],
                );
                if (result['selection'] != null) {
                    if(result['selection']![0] == '1'){

                       AppConstants.learnInEnglish = !AppConstants.learnInEnglish;

                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  prefs.setBool('learnInEnglish',AppConstants.learnInEnglish);

                  //questions ko dubara set ker wanahai

                  getQuestions();


                    }else{
                    Get.find<QuestionController>().hideOrShowTranslation();

                    }
                  }
              },
              icon: Icon(
                Icons.settings_rounded,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
              // icon: Image.asset(Images.,color: Theme.of(context).primaryColor,),
            ),
          ],
        ),
      
        // appBar: CustomAppBar(
        //   title: 'Testfragen #' + (currentIndex + 1).toString(),
          
        //   leading: InkWell(
        //     borderRadius: BorderRadius.circular(100),
        //     onTap: () {
        //       zoomDrawerController.toggle?.call();
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.all(5.0),
        //       child: Image.asset(
        //         Images.menu,
        //         width: 22,
        //         height: 22,
        //       ),
        //     ),
        //   ),
        //   showLeading: true,
        //   onBack: () {
        //     Get.back(result: {"nextCategoryIndexToView": currentIndex});
        //   },
        //   trailing: [
        //     IconButton(
        //       onPressed: () async {
        //         Map<String, List<String>?> result =
        //             await CustomBottomSheetSelector<String>().customBottomSheet(
        //           buildContext: context,
        //           selectedItemColor: Theme.of(context).primaryColorLight,
        //           initialSelection: [
        //             Get.find<QuestionController>().isShowTranslation
        //                ? "Übersetzung ausblenden"
        //                   : "Übersetzung zeigen"
        //           ],
        //           buttonType: CustomDropdownButtonType.singleSelect,
        //           headerName: "Einstellungen",
        //           dropdownItems: [
        //             CustomMultiSelectDropdownItem(
        //                 Get.find<QuestionController>().isShowTranslation
        //                    ? "Übersetzung ausblenden"
        //                   : "Übersetzung zeigen",
        //                 Get.find<QuestionController>().isShowTranslation
        //                     ? "Übersetzung ausblenden"
        //                   : "Übersetzung zeigen"),
        //                       CustomMultiSelectDropdownItem('1', AppConstants.learnInEnglish? 'Auf Deutsch lernen': 'Learn in English')
        //           ],
        //         );
        //         if (result['selection'] != null) {
        //             if(result['selection']![0] == '1'){

        //                AppConstants.learnInEnglish = !AppConstants.learnInEnglish;

        //           SharedPreferences prefs = await SharedPreferences.getInstance();

        //           prefs.setBool('learnInEnglish',AppConstants.learnInEnglish);

        //           //questions ko dubara set ker wanahai

        //           getQuestions();


        //             }else{
        //             Get.find<QuestionController>().hideOrShowTranslation();

        //             }
        //           }
        //       },
        //       icon: Icon(
        //         Icons.settings_rounded,
        //         color: Theme.of(context).primaryColor,
        //         size: 28,
        //       ),
        //       // icon: Image.asset(Images.,color: Theme.of(context).primaryColor,),
        //     ),
        //   ],
        // ),
     
        body: SafeArea(
            child: SmartRefresher(
          onRefresh: () async {
            await Get.find<QuestionController>()
                .fetchTrialQuestions(isFromInitState: false);
            if (currentIndex >
                Get.find<QuestionController>().questions.length) {
              currentIndex = 0;
              setState(() {});
            }
            _refreshController.refreshCompleted();
          },
          controller: _refreshController,
          physics: BouncingScrollPhysics(),
          child: Container(
            width: context.width,
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL),
            margin: EdgeInsets.zero,
            child:
                GetBuilder<QuestionController>(builder: (questionController) {
              return !questionController.isDataFetching
                  ? Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: questionController.questions.length,
                              scrollDirection: Axis.horizontal,
                              controller: pageViewController,
                              onPageChanged: (index) {
                                setState(() {
                                  currentIndex = index;
                                  id = questionController.questions[index].id
                                      .toString();
                                });
                              },
                              itemBuilder: (context, position) {
                                Question question =
                                    questionController.questions[position];

                                return QuestionItemWidget(
                                  question: question,
                                  testMode: false,
                                  questionIndex: position,
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (currentIndex != 0)
                              Expanded(
                                child: Container(
                                  // margin: const EdgeInsets.only(right: 10),
                                  child: CustomButton(
                                    fontSize: 12,
                                    height: 44,
                                    backgroundTransparent: true,
                                    buttonText: AppString.previous.tr,
                                    onPressed: () {
                                      questionController.hideOrShowAnswer(
                                          isShowAnswer: false);
                                      currentIndex--;
                                      pageViewController
                                          .jumpToPage(currentIndex);
                                      // pageViewController.animateToPage(currentIndex, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                  ),
                                ),
                              ),
                            if (currentIndex != 0)
                              const SizedBox(
                                width: 5,
                              ),
                            Expanded(
                              child: CustomButton(
                                height: 44,
                                fontSize:  !questionController.isShowAnswer ?11:9,
                                buttonText: questionController.isShowAnswer
                                    ? 'Antwort Verstecken'
                                              : 'Antwort Zeigen',
                                onPressed: () {
                                  questionController.hideOrShowAnswer();
                                },
                              ),
                            ),
                            if (currentIndex + 1 !=
                                questionController.questions.length)
                              const SizedBox(
                                width: 5,
                              ),
                            if (currentIndex + 1 !=
                                questionController.questions.length)
                              Expanded(
                                child: Container(
                                  // margin: const EdgeInsets.only(left: 5),
                                  child: CustomButton(
                                    fontSize: 12,
                                    height: 44,
                                    // width: 80,
                                    backgroundTransparent: true,
                                    buttonText: AppString.next.tr,
                                    onPressed: () {
                                      questionController.hideOrShowAnswer(
                                          isShowAnswer: false);
                                      currentIndex++;
                                      FocusScope.of(context).unfocus();

                                      pageViewController
                                          .jumpToPage(currentIndex);
                                      // pageViewController.animateToPage(currentIndex, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (currentIndex + 1 ==
                                questionController.questions.length)
                              Container(
                                // margin: const EdgeInsets.only(left: 5),
                                child: CustomButton(
                                  fontSize: 12,
                                  height: 44,
                                  // width: 80,
                                  backgroundTransparent: true,
                                  buttonText: 'Beginnen Sie von vorne',
                                  onPressed: () {
//ager click hota hai to hum ne isse 1 per le jana hai

            currentIndex = 0;
            pageViewController
                                          .jumpToPage(currentIndex);
            setState(() {
              
            });


                                   },
                                ),
                              ),
                       if (currentIndex + 1 ==
                                questionController.questions.length) const SizedBox(
                          height: 12,
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: context.width * .3),
                        child: LoadingAnimationWidget.flickr(
                          leftDotColor: AppColor
                              .primaryGradiantStart, //Get.theme.primaryColor,
                          rightDotColor: AppColor.primaryGradiantEnd,
                          size: 50,
                        ),
                      ),
                    );
            }),
          ),
        )),
        bottomNavigationBar:
            Get.find<AuthController>().getLoginUserData()?.paymentStatus != "1"
                ? GestureDetector(
                    onTap: () {
                       if(Get.find<AuthController>()
                                  .getLoginUserData() != null){
        Get.toNamed(RouteHelper.getPurchasePlanScreenRoute());

                                  }else{
                                    showCustomSnackBar('Sie müssen sich zuerst anmelden', isError: false);
        Get.toNamed(RouteHelper.getSignInRoute());

                                  }
                    },
                    child: Container(
                      alignment: Alignment.center,

                      height: 60,
                      // minWidth: width,
                      color: Theme.of(context).primaryColor,

                      child: Text("Vollversion Kaufen",
                          textAlign: TextAlign.center,
                          style: ralewayBold.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeDefault,
                          )),
                    ),
                  )
                : const SizedBox(),
      ),
    );
  }
}
