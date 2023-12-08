import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/controller/translation_language_controller.dart';
import 'package:Fahren123/data/model/response/language_model.dart';
import 'package:Fahren123/util/app_constants.dart';
import 'package:Fahren123/util/app_strings.dart';
import 'package:Fahren123/util/color_constants.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/util/styles.dart';
import 'package:Fahren123/view/base/custom_app_bar.dart';
import 'package:Fahren123/view/base/my_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectLanguageScreen extends StatefulWidget {
  final bool isFromLogin;
  const SelectLanguageScreen({Key? key, required this.isFromLogin}) : super(key: key);

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {

  TranslationLanguageModel ?selectedLanguage;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
late ZoomDrawerController zoomDrawerController;
  @override
  void initState() {
    Get.find<TranslationLanguageController>().fetchLanguagesList(isFromInit: true);
    super.initState();
    zoomDrawerController = ZoomDrawerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const CustomAppBar(title: AppString.selectLanguage, leading: null,showLeading: true,),
      body: SafeArea(
          child: SmartRefresher(
            onRefresh: ()async{
              await Get.find<TranslationLanguageController>().fetchLanguagesList(isFromInit: false);
              _refreshController.refreshCompleted();
            },
            controller: _refreshController,
            child: Container(
              width: context.width,
              // height: context.height,
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              margin: EdgeInsets.zero,
              child: GetBuilder<TranslationLanguageController>(builder: (translationLanguageController) {
                if(!translationLanguageController.isDataFetching || translationLanguageController.languagesList.isNotEmpty){
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: translationLanguageController.languagesList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index){
                                TranslationLanguageModel languageModel = translationLanguageController.languagesList[index];
                                if(languageModel.isSelected){
                                  selectedLanguage = languageModel;
                                }
                                return InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: (){
                                    translationLanguageController.languagesList.every((language){
                                      language.isSelected= false;
                                      return true;
                                    });
                                    languageModel.isSelected = true;
                                    selectedLanguage = languageModel;
                                    setState((){});
                                  },
                                  child: Container(
                                    height: 60,
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: languageModel.isSelected ? Border.all(color: Theme.of(context).primaryColor):null,
                                      color: const Color(0xFFF9F9F9),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 20,),
                                        CachedNetworkImage(
                                          imageUrl: AppConstants.STORAGE_URL+languageModel.imageUrl,
                                          height: 33,
                                          width: 59,
                                          memCacheWidth: (context.width).toInt(),
                                          cacheKey: AppConstants.STORAGE_URL+languageModel.imageUrl,
                                        ),
                                        // Image.asset(languageModel.imageUrl,height: 33,width: 49,),
                                        const SizedBox(width: 20,),
                                        Text(
                                          "${languageModel.languageName}${languageModel.languageName.isNotEmpty && languageModel.nativeName.isNotEmpty?' _ ':''}${languageModel.nativeName}",
                                          style: ralewayRegular.copyWith(fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                          )
                        ),
                        PostDoneButton(
                            onPressed: (){

                            
                             
                              selectedLanguage!.isSelected=true;
                              translationLanguageController.updateTranslationLanguage(translationLanguage: selectedLanguage!, isFromLogin: widget.isFromLogin);
                             
                          
                            },
                        ),
                      ]);
                }else{
                  return Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: context.width*.3),
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
          )),
      // body: SafeArea(
      //     child: SingleChildScrollView(
      //       physics: const BouncingScrollPhysics(),
      //       child: Container(
      //         width: context.width,
      //         height: context.height,
      //         padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      //         child: GetBuilder<TranslationLanguageController>(builder: (translationLanguageController) {
      //           return Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               translationLanguageController.languagesList.isNotEmpty
      //                   ? ListView.builder(
      //                   shrinkWrap: true,
      //                   itemCount: translationLanguageController.languagesList.length,
      //                   itemBuilder: (BuildContext context, int index){
      //                     TranslationLanguageModel languageModel = translationLanguageController.languagesList[index];
      //                     return InkWell(
      //                       borderRadius: BorderRadius.circular(8),
      //                       onTap: (){
      //                         setState((){
      //                           selectedLanguage = languageModel;
      //                         });
      //                       },
      //                       child: Container(
      //                         height: 60,
      //                         margin: const EdgeInsets.symmetric(vertical: 5),
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(8),
      //                           border: selectedLanguage==languageModel ? Border.all(color: Theme.of(context).primaryColor):null,
      //                           color: const Color(0xFFF9F9F9),
      //                         ),
      //                         child: Row(
      //                           crossAxisAlignment: CrossAxisAlignment.center,
      //                           children: [
      //                             const SizedBox(width: 20,),
      //                             Image.asset(languageModel.imageUrl,height: 33,width: 49,),
      //                             const SizedBox(width: 20,),
      //                             Text(
      //                               "${languageModel.languageName}${languageModel.languageName.isNotEmpty && languageModel.nativeName.isNotEmpty?' _ ':''}${languageModel.nativeName}",
      //                               style: ralewayRegular.copyWith(fontSize: 16),
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                     );
      //                   }
      //               )
      //                   : Center(
      //                 child: Container(
      //                   margin: EdgeInsets.only(bottom: context.width*.3),
      //                   child: LoadingAnimationWidget.flickr(
      //                     leftDotColor: AppColor.primaryGradiantStart,//Get.theme.primaryColor,
      //                     rightDotColor: AppColor.primaryGradiantEnd,
      //                     size: 50,
      //                   ),
      //                 ),
      //               )
      //             ],
      //           );
      //         }),
      //       ),
      //     )),
    );
  }
}
