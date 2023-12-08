import 'package:flutter/material.dart';

import '../../util/color_constants.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final bool transparent;
  final bool backgroundTransparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final Color? color;
  final double? radius;
  final IconData? icon;
  const CustomButton(
      {Key? key,
      required this.onPressed,
      required this.buttonText,
      this.transparent = false,
      this.backgroundTransparent = false,
      this.margin,
      this.width,
      this.height,
      this.fontSize,
      this.radius,
      this.color,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    //   backgroundColor: onPressed == null ? Theme.of(context).disabledColor : transparent
    //       ? Colors.transparent : Theme.of(context).primaryColor,
    //   minimumSize: Size(width ?? Dimensions.WEB_MAX_WIDTH, height ?? 50),
    //   padding: EdgeInsets.zero,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(radius),
    //   ),
    // );

    return Center(
        child: SizedBox(
            width: width ?? double.infinity,
            child: Container(
              padding: margin ?? const EdgeInsets.all(0),
              height: height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS),
                  border: backgroundTransparent
                      ? Border.all(color: Theme.of(context).primaryColor)
                      : null,
                  color: color != null
                      ? color
                      : backgroundTransparent
                          ? Colors.transparent
                          : Theme.of(context).primaryColor),
              child: MaterialButton(
                onPressed: onPressed,

                height: height,
                minWidth: width,
                // color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  icon != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                              right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Icon(icon,
                              color: transparent
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).cardColor),
                        )
                      : const SizedBox(),
                  Text(buttonText,
                      textAlign: TextAlign.center,
                      style: ralewayBold.copyWith(
                        color: backgroundTransparent || transparent
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        fontSize: fontSize ?? Dimensions.fontSizeDefault,
                      )),
                ]),
              ),
            )));
  }
}
