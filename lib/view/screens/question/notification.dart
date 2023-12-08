

import 'package:Fahren123/helper/route_helper.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/app_strings.dart';
import '../../base/custom_button.dart';

class NotificationScreen extends StatefulWidget {
  List notificationlist;
   NotificationScreen({Key? key, required this.notificationlist})
      : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // List<Question> questions = [];
  late PageController pageViewController;
  final List<Widget> _pageViewItem = <Widget>[];
  int currentIndex = 0;
  int questionNumber = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {

    
    super.initState();
  }


 
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar : AppBar(
    toolbarHeight: 80,
    elevation: 8,
    backgroundColor: Colors.white,
    centerTitle: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(16))),
    // backgroundColor: Colors.yellow,
    leading: Container(
            // decoration: BoxDecoration(
            //   shape: BoxShape.circle,
            //   color: Colors.black26,
            //   border: Border.all(color: Colors.black26),
            // ),
            // margin: const EdgeInsets.only(left: 10),
            child: InkWell(
                radius: 100,
                borderRadius: BorderRadius.circular(100),
                onTap: () {
   
                       Get.back();

                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                )),
          ),
    title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  children: [
                    Text(
                      'Notifications',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: ralewayMedium.copyWith(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                   
                  ],
                ),
              ),
            ],
          )
        ,
    actions: [
      Container(width: 50,)
          ]

    
    ),
     
      //  CustomAppBar(
      //   title: widget.questionCategory.primaryName +
      //       ' # ' +
      //       (currentIndex + 1).toString(),
      //   leading: null,
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
      //                 ? "Übersetzung ausblenden"
      //                 : "Übersetzung zeigen"
      //           ],
      //           buttonType: CustomDropdownButtonType.singleSelect,
      //           headerName: "Settings",
      //           dropdownItems: [
      //             CustomMultiSelectDropdownItem(
      //                 Get.find<QuestionController>().isShowTranslation
      //                     ? "Übersetzung ausblenden"
      //                     : "Übersetzung zeigen",
      //                 Get.find<QuestionController>().isShowTranslation
      //                     ? "Übersetzung ausblenden"
      //                     : "Übersetzung zeigen")
      //           ],
      //         );
      //         if (result['selection'] != null) {
      //           Get.find<QuestionController>().hideOrShowTranslation();
      //         }
      //       },
      //       // icon: Icon(Icons.translate_rounded,),
      //       icon: Icon(
      //         Icons.settings_rounded,
      //         color: Theme.of(context).primaryColor,
      //         size: 28,
      //       ),
      //     ),
      //   ],
      // ),
      body: SafeArea(
          child: Container(
            width: context.width,
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL * 2),
            // margin: EdgeInsets.zero,
            child: SingleChildScrollView(
              child: Column(
            
                children: List.generate(widget.notificationlist.length, (i) =>  Column(
                  children: [
                    ListTile(
                      
                      title: Text(widget.notificationlist[i]['notificationTitle'], style: ralewayMedium,),
                      subtitle: Text(widget.notificationlist[i]['notificationText'], style: ralewayRegular),
             
            
                      
                    ),
                    if(widget.notificationlist[i]['notificationType'] == 'Plan Renewal' ) GestureDetector(
                      onTap: (){
               
                    Get.toNamed(RouteHelper.getPurchasePlanScreenRoute());
            
                                    
                      },
                      child: Container(
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xffFFBF00),
               
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
                    ),
                    SizedBox(height: 10,),
                  ],
                )),
              ),
            )
               
          )),
    );
  }
}
