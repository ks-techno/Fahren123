import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/util/images.dart';
import 'package:Fahren123/util/styles.dart';
import 'package:Fahren123/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../util/app_strings.dart';

class NoInternetScreen extends StatelessWidget {
  final Widget child;
  const NoInternetScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.025),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.no_internet, width: 150, height: 150),
            Text('oops'.tr, style: ralewayBold.copyWith(
              fontSize: 30,
              color: Theme.of(context).textTheme.bodyText1!.color,
            )),
            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              'no_internet_connection'.tr,
              textAlign: TextAlign.center,
              style: ralewayRegular,
            ),
            const SizedBox(height: 40),
            Container(
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomButton(
                onPressed: () async {
                  if(await Connectivity().checkConnectivity() != ConnectivityResult.none) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => child));
                  }
                },
                buttonText: AppString.retry.tr,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
