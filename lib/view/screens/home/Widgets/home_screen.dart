import 'package:Fahren123/controller/categories_controller.dart';
import 'package:Fahren123/controller/question_controller.dart';
import 'package:Fahren123/custom_packages/customselector/utils/enum.dart';
import 'package:Fahren123/custom_packages/customselector/utils/flutter_custom_select_item.dart';
import 'package:Fahren123/custom_packages/customselector/widget/flutter_custom_selector_sheet.dart';
import 'package:Fahren123/data/model/response/category_model.dart';
import 'package:Fahren123/enums/category.dart';
import 'package:Fahren123/helper/route_helper.dart';
import 'package:Fahren123/util/app_constants.dart';
import 'package:Fahren123/util/color_constants.dart';
import 'package:Fahren123/view/base/custom_button.dart';
import 'package:Fahren123/view/base/custom_snackbar.dart';
import 'package:Fahren123/view/base/loading_widget.dart';
import 'package:Fahren123/view/screens/privacy%20policy/instructions.dart';
import 'package:Fahren123/view/screens/question/notification.dart';
import 'package:Fahren123/view/screens/question/test_question_screen.dart';
import 'package:accordion/controllers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:Fahren123/util/images.dart';
import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/view/base/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../util/app_strings.dart';
import '../../../../util/styles.dart';
import '../main_screen.dart';
import 'weather_widget.dart';
import 'package:accordion/accordion.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key,}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  late Size deviceSize;
  late double weatherCardWidth;
  late double weatherCardHeight;
  List<Widget> weatherItemList= <Widget>[];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
 List notificationlist = [];

double totalPercentage = 100;
double totalCategory = 11;
  double readPercentageQuestion = 0;
  double readPercentageCategory = 0;
   bool alreadyRead = true;
    bool isOpen1 = false; 
  bool isOpen2 = false; 
bool isOpenPerformance = false;
  @override
  void initState() {
    Get.find<CategoryController>().fetchCategories(isFromInitState:true);

    getPerformanceandnotifications();
    check();
    super.initState();
  }

   check() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();

                 AppConstants.learnInEnglish =  prefs.getBool('learnInEnglish')?? false;
                 setState(() {
                   
                 });
  }

    markNotificationRead(id){

    debugPrint(id);

    Get.find<QuestionController>()
        .readNotification(
          id.toString()
           )
        .then((value) {
debugPrint('mein hun notifications -------------------------');
debugPrint(value.toString());


         
      


     
    });

  }

    getPerformanceandnotifications(){


    Get.find<QuestionController>()
        .fetchPerformance(
           )
        .then((value) {

          debugPrint("value.toString()----------------------------");
          debugPrint(value.toString());

         
      if(value['Success'] != null && value['Success']['success'] == true){
 
        try{
          totalPercentage = double.parse(value['Success']['result'][0]['total_percentage'].toString());
          totalCategory = double.parse(value['Success']['result'][0]['total_category'].toString());
          readPercentageQuestion = double.parse(value['Success']['result'][0]['read_percentage_question'].toString());
          readPercentageCategory = double.parse(value['Success']['result'][0]['read_percentage_category'].toString());
        }catch(e){
          // showCustomSnackBar(e.toString());
        }

      }

    

      setState(() {
        
      });
     
    });

    //lets get notifications as well
     Get.find<QuestionController>()
        .fetchNotification(
           )
        .then((value) async {
debugPrint('mein hun notifications -------------------------');
debugPrint(value.toString());
         
      if(value['Success'] != null && value['Success']['success'] == true){
 debugPrint("--------------------------------------------");
          debugPrint(value.toString());
        try{
          notificationlist = value['Success']['result'];

          if(notificationlist.isNotEmpty && notificationlist[0]['notificationID'] == '1'){
            //hum dekhein ge k is ne iss month mein read kiya hai ya nahi

SharedPreferences prefs = await SharedPreferences.getInstance();
            alreadyRead = prefs.getString('notiReadMonth')  == DateTime.now().month.toString() ? true: false;
          }
          else if(notificationlist.isNotEmpty){
            //hum pehle index ko check ker lein ge k iss ne read kiya hua hai ya nahi
            alreadyRead = notificationlist[0]['is_read'] == true ? true: false;
          }
        }catch(e){
          showCustomSnackBar(e.toString());
        }

      }

    

      setState(() {
        
      });
     
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: CustomAppBar(
        title: AppString.home,
        leading: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: (){
            zoomDrawerController.toggle?.call();
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(Images.menu,width: 22,height: 22,),
          ),
        ),
        showLeading: true,
        trailing: [
          Container(
            width: 50,
            child: GestureDetector(
                onTap: ()async{
                  Map<String, List<String>?> result = await CustomBottomSheetSelector<String>().customBottomSheet(
                    buildContext: context,
                    selectedItemColor: Theme.of(context).primaryColorLight,
                    initialSelection: ['1'],
                    buttonType: CustomDropdownButtonType.singleSelect,
                    headerName: "Einstellungen",
          
                    dropdownItems: [
                      // CustomMultiSelectDropdownItem('1','Take Test #1'),
                      // CustomMultiSelectDropdownItem('2','Take Test #2'),
                       CustomMultiSelectDropdownItem('', AppConstants.learnInEnglish? 'Auf Deutsch lernen': 'Learn in English')
                      ],
                  );
                  if(result['selection']!=null){
          
                   
              //              List<String>?  test = result['selection']; 
          
              //               //yahan se hum ne isko 2sre page per le ker jana hai
          
          
              // Navigator.push(context, MaterialPageRoute(builder: (context) => InstructionScreen(testNumber: test![0],)));
          
            AppConstants.learnInEnglish = !AppConstants.learnInEnglish;
          
                    SharedPreferences prefs = await SharedPreferences.getInstance();
          
                    prefs.setBool('learnInEnglish',AppConstants.learnInEnglish);
          
                    
                  setState((){});
          
                   
                  }
                },
                // child: Image.asset(Images.takeTest,width: 30,),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(right:10),
                    height: 32,
                    width: 32,
                    child: Image.asset(
                         AppConstants.learnInEnglish?  Images.german : Images.english,
                          color: Colors.black,
                        ),
                  ),
                ),
            ),
          ),
          const SizedBox(width: 10,),
        ],
      ),
      body: SafeArea(
          child: SmartRefresher(
            onRefresh: ()async{
              await Get.find<CategoryController>().fetchCategories(isFromInitState:false);
              _refreshController.refreshCompleted();
            },
            controller: _refreshController,
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(top:20, bottom: 20),
              shrinkWrap: true,
              children: [

                Container(
                  width: context.width,
                  // height: context.height,
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  margin: EdgeInsets.zero,
                  child: GetBuilder<CategoryController>(builder: (categoryController) {
                    if(!categoryController.isDataFetching || categoryController.categories.isNotEmpty){
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            if(notificationlist.isNotEmpty) Accordion(
      maxOpenSections: 1,
          headerBackgroundColorOpened: Colors.black54,
          scaleWhenAnimating: true,
          openAndCloseAnimation: true,
          contentBorderColor: Colors.grey.shade100.withOpacity(.7),
          headerPadding:
              const EdgeInsets.symmetric(vertical: 7, horizontal: 15),

              paddingListBottom: 0,
              paddingListTop: 7,
              
          
              
          sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
          sectionClosingHapticFeedback: SectionHapticFeedback.light,
          children: [
            AccordionSection(  isOpen: isOpen1,
            onOpenSection: () async {
               if(alreadyRead ==  false && notificationlist.isNotEmpty && notificationlist[0]['notificationID'] == '1'){

                 //iska matlab ye plan wala hai , hmein is month ko save kerwana hai

                 SharedPreferences prefs = await SharedPreferences.getInstance();
                 prefs.setString('notiReadMonth', DateTime.now().month.toString());

                 debugPrint('mein to yahan hun');

                 
             

              }
               else if(alreadyRead ==  false && notificationlist.isNotEmpty && notificationlist[0]['is_read'] != true){


              markNotificationRead(notificationlist[0]['notificationID']);

              }
              setState(()  {
                isOpen1 = true;
                alreadyRead = true;

               

              });

             

          
            },

            onCloseSection: (){
                setState(() {
                isOpen1 = false;
              });
            },
            
            
              leftIcon:  Icon(Icons.notifications_active_outlined, color: !isOpen1? Colors.black : Colors.white),
            rightIcon: Icon(Icons.keyboard_arrow_down_rounded, color: !isOpen1? Colors.black : Colors.white) ,
            flipRightIconIfOpen: true,
              headerBackgroundColor: Colors.grey.shade100.withOpacity(.7),
              headerBackgroundColorOpened: Theme.of(context).primaryColor,
              header: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notifications', style: ralewayMedium.copyWith(color: !isOpen1? Colors.black : Colors.white) ),
                   if(!isOpen1 && !alreadyRead)Container(
                  // margin: EdgeInsets.only(right: 16),
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  alignment: Alignment.center,
                  child: Text(notificationlist.length.toString(), style: ralewayMedium.copyWith(color: Colors.white),),
                ),
                ],
              ), content: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.end,
  mainAxisSize: MainAxisSize.min,
  children: 

    List.generate(notificationlist.length > 0? 1 :0, (i) => 
    Column(
      children: [
        ListTile(
          
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(notificationlist[i]['notificationTitle'].toString(), style: ralewayMedium,)),
              if(notificationlist.length > 1)GestureDetector(
                onTap: (){

                  Navigator.push(context, MaterialPageRoute(builder: (context)=> NotificationScreen(notificationlist: notificationlist,)));

                },
                child: Text('View All', style: ralewayMedium.copyWith(color:Theme.of(context).primaryColor,decoration: TextDecoration.underline ),)),
            ],
          ),
          subtitle: Text(notificationlist[i]['notificationText'].toString(), style: ralewayRegular,),
 

          
        ),
        if(notificationlist[i]['notificationType'] == 'Plan Renewal' ) GestureDetector(
          onTap: (){
             
        Get.toNamed(RouteHelper.getPurchasePlanScreenRoute());

                                  
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).primaryColor,
             
            ),
            child: Center(
              child: Text(
               'Renew',
                style: ralewayBold.copyWith(
                  color: Colors.white,
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
            ),
          ),
        )
      ],
    )
    )


                       

  ,
))
          ],
 ) ,


                Accordion(
                  maxOpenSections: 1,
          headerBackgroundColorOpened: Colors.black54,
          scaleWhenAnimating: true,
          openAndCloseAnimation: true,
          contentBorderColor: Colors.grey.shade100.withOpacity(.7),
          headerPadding:
              const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          
              
          sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
          sectionClosingHapticFeedback: SectionHapticFeedback.light,

                  children: [
                     AccordionSection(

             isOpen: isOpenPerformance,
              onOpenSection: (){
                setState(() {
                  isOpenPerformance = true;
                });
              },
              onCloseSection: (){
                setState(() {
                  isOpenPerformance = false;
                });
              },
              leftIcon: const Icon(Icons.insights_rounded, color: Colors.black),
            rightIcon:const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black) ,
            flipRightIconIfOpen: true,
              headerBackgroundColor: Colors.grey.shade100.withOpacity(.7),
              headerBackgroundColorOpened: Theme.of(context).primaryColor,
              header: Text('Leistung', style: ralewayMedium ),
              content:  Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
                        _getRadialGauge(1),
                       
                        // _getRadialGauge(2),
                        // SizedBox(width: 5,),

                        // _getRadialGauge(3),

  ],
),
              contentHorizontalPadding: 0,
              contentBorderWidth: 1,
              // onOpenSection: () => print('onOpenSection ...'),
              // onCloseSection: () => print('onCloseSection ...'),
            ),
                  ]),
                          
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 3 / 3.2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10
                                ),
                                itemCount: categoryController.categories.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  QuestionCategory category = categoryController.categories[index];
                                int viewedQuestions = (Get.find<SharedPreferences>().getInt("${AppConstants.CATEGORY_QUESTONS_VIEWED}${category.id}")??0)+1;

                                  return DelayedDisplay(
                                    slidingBeginOffset: Offset( index.isEven? -1: 1,0),
                                    child: InkWell(
                                      onTap: ()async{
                                        dynamic result = await Get.toNamed(RouteHelper.getQuestionScreenRoute(questionCategory: category))??{"nextCategoryIndexToView":0};
                                        if(result["nextCategoryIndexToView"]+1>viewedQuestions){
                                        Get.find<SharedPreferences>().setInt("${AppConstants.CATEGORY_QUESTON_TO_VIEW_INDEX}${category.id}", result["nextCategoryIndexToView"]);

                                          Get.find<SharedPreferences>().setInt("${AppConstants.CATEGORY_QUESTONS_VIEWED}${category.id}", result["nextCategoryIndexToView"]);
                                        }
                                      
                                          setState((){});
                                        
                                        getPerformanceandnotifications();

                                      },
                                      radius: 15,
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100.withOpacity(.7),
                                          // gradient: AppColor.boxGradient,
                                            // border: Border.all(color: Theme.of(context).primaryColor),
                                            borderRadius: BorderRadius.circular(15)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 50,
                                              width: 50,
                                              child: OptimizedCacheImage(
                                                imageUrl: AppConstants.STORAGE_URL+category.imageUrl,
                                                height: 500,
                                                width: 500,
                                              ),
                                            ),
                                            const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                                            Text(
                                              category.primaryName.tr,
                                              textAlign: TextAlign.center,
                                              style: ralewayMedium.copyWith(
                                                fontSize: 15,
                                                color: Theme.of(context).primaryColorLight,
                                                fontWeight: FontWeight.w700
                                              ),
                                            ),
                                            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
                                            category.secondaryName.isNotEmpty
                                                ? Text(
                                              category.secondaryName.tr,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.getFont(Get.find<AuthController>().getLoginUserData()!.translationLanguage!.fontFamily).copyWith(
                                                  fontSize: 15,
                                                  color: Theme.of(context).primaryColorLight,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            )
                                                : const SizedBox(),
                                            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
                                            viewedQuestions>1
                                                ? Text(
                                                  "👁️ $viewedQuestions angesehen",
                                                  textAlign: TextAlign.center,
                                                  style: ralewayRegular.copyWith(
                                                      fontSize: 12,
                                                      color: Theme.of(context).primaryColorLight,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                )
                                                : const SizedBox()
                                        
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ]);
                    }else{
                      return Center(
                        child: SizedBox(
                          height: context.height*.8,
                          child: LoadingAnimationWidget.flickr(
                            leftDotColor: AppColor.primaryGradiantStart,//Get.theme.primaryColor,
                            rightDotColor: AppColor.primaryGradiantEnd,
                            size: 50,
                          ),
                        ),
                      );
                    }
                  }),
                ),
              ],
            ),
          )),
    );
  }


 Widget _getRadialGauge(int number) {

   double readPercentage = number == 1? readPercentageQuestion: readPercentageCategory;
   double total = number == 1? totalPercentage: totalCategory;
    return Container(
      height:  160 ,
      width:  160 ,
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        
          axes: <RadialAxis>[
            RadialAxis(
              showLabels: true,
              showTicks: true,
              minimum: 0, maximum: total, ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0,
                  endValue: readPercentage,
                  color: readPercentage< 40? AppColor.primaryGradiantStart: readPercentage < 80? AppColor.primaryGradiantEnd: Colors.green ,
                  startWidth: 10,
                  endWidth: 10),
              
            ], pointers: <GaugePointer>[
              NeedlePointer(value: readPercentage,
              needleColor: AppColor.primaryGradiantStart,
              needleEndWidth: 3,
              needleStartWidth: 0,
              knobStyle: KnobStyle(
                color: AppColor.primaryGradiantStart
              ),
              )
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Container(
                      child:  Text(readPercentage.toStringAsFixed(0) +(number == 1? ' %':' Kategorien'),
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  angle: 90,
                  positionFactor: 0.8)
            ])
          ]),
    );
  }
}