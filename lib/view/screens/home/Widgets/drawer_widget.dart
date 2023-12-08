import 'dart:io';

import 'package:Fahren123/controller/auth_controller.dart';
import 'package:Fahren123/view/base/custom_dialog_box.dart';
import 'package:Fahren123/view/screens/auth/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:Fahren123/helper/route_helper.dart';
import 'package:Fahren123/util/app_strings.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/util/styles.dart';
import 'package:Fahren123/view/screens/home/main_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../util/images.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    zoomDrawerController.toggle?.call();
                  },
                  icon: Icon(
                    Icons.highlight_remove,
                    color: Theme.of(context).primaryColorLight,
                  ))
            ],
          ),
          const SizedBox(
            height: Dimensions.PADDING_SIZE_LARGE,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13),
            child: Image.asset(Images.logo, width: 155),
          ),
          const SizedBox(
            height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
          ),

           /// My Profile
          if(Get.find<AuthController>().getLoginUserData() != null)  DrawerItem(
            title: "My Profile",
            onPressed: () {

              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen()));
              
            },
            leadingImage: Images.profile_black,
          ),

          /// Language Selection
          DrawerItem(
            title: AppString.selectLanguage,
            onPressed: () {
              Get.toNamed(RouteHelper.getSelectLanguageRoute());
            },
            leadingImage: Images.privacy,
          ),

          /// Privacy Policy
          DrawerItem(
            title: AppString.privacyPolicy,
            onPressed: () {
              Get.toNamed(RouteHelper.getPrivacyPolicyRoute());
            },
            leadingImage: Images.privacy,
          ),

          /// Change password
          if(Get.find<AuthController>().getLoginUserData() != null)  DrawerItem(
            title: AppString.changePassword,
            onPressed: () {
              Get.toNamed(RouteHelper.getChangePasswordRoute(
                  isChangePassword: true, email: ''));
            },
            leadingImage: Images.lock,
          ),

          DrawerItem(
            title: AppString.shareApp,
            onPressed: () async {
              zoomDrawerController.toggle?.call();
              var link = Platform.isIOS
                  ? 'https://apps.apple.com/us/app/fahren123/id1660576708'
                  : 'https://play.google.com/store/apps/details?id=de.fahren123';
              await FlutterShare.share(
                title: 'Share Fahren123 with your friends',
                text: 'Share Fahren123 with your friends',
                linkUrl: link,
              );

              // final box = context.findRenderObject() as RenderBox?;

              // Share.share(link,
              //     sharePositionOrigin:
              //         box!.localToGlobal(Offset.zero) & box.size);
            },
            leadingImage: Images.share,
          ),
         if(Get.find<AuthController>().getLoginUserData() != null)  DrawerItem(
            title: AppString.logout,
            onPressed: () async {
              bool isConfirmed = await showCustomDialog(
                context: context,
                descriptions: AppString.logoutMessage,
                title: AppString.logout,
              );
              if (isConfirmed) {
                Get.find<AuthController>().logout('');
              }
            },
            leadingImage: Images.logout,
          ),

        if(Get.find<AuthController>().getLoginUserData() != null)   SizedBox(
            height: 30,
          ),

          /// Delete Account
        if(Get.find<AuthController>().getLoginUserData() != null)   DrawerItem(
              title: AppString.deleteAccount,
              onPressed: () async {
                bool isConfirmed = await showCustomDialog(
                  context: context,
                  descriptions: AppString.deleteAccountMessage,
                  title: AppString.deleteAccount,
                );
                if (isConfirmed) {
                  // Get.find<AuthController>().logout('');
                  Get.find<AuthController>().deleteAccount();
                }
              },
              leadingImage: Images.delete,
              leadingImageColor: Colors.red),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final String leadingImage;
  final Color? leadingImageColor;
  final void Function() onPressed;
  const DrawerItem(
      {Key? key,
      required this.title,
      required this.onPressed,
      required this.leadingImage,
      this.leadingImageColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                leadingImage,
                width: 18,
                height: 18,
                color: leadingImageColor,
              ),
              const SizedBox(
                width: Dimensions.PADDING_SIZE_SMALL,
              ),
              Expanded(
                child: Text(
                  title,
                  style: ralewayRegular.copyWith(
                      fontSize: 16,
                      color:
                          title == 'Delete account' ? Colors.red : Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
