import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskly/framework/constants/app_style.dart';
import 'package:taskly/framework/constants/app_utils.dart';

class AppButton extends StatelessWidget {

  const AppButton({
    super.key, 
    required this.color,
    this.text = "",
    this.icon,
    this.action,
    this.isFilledButton = true,
    this.colorText = ApplicationColors.DARK_1,
    this.textSize = 18,
    this.height = 40.0,
    this.specificCornerRadius,
    this.noRadius = false,
    this.paddingHorizontal = 20,
    this.paddingVertical = 8,
    this.width,
    this.margin
  });

  final Color color;
  final String text;
  final VoidCallback? action;
  final bool isFilledButton;
  final Color colorText;
  final double textSize;
  final double height;
  final SvgPicture? icon;
  final BorderRadius? specificCornerRadius;
  final bool? noRadius;
  final double paddingHorizontal;
  final double paddingVertical;
  final double? width;
  final EdgeInsets? margin;


  @override
  Widget build(BuildContext context) {
    final isActive = action != null;
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: ElevatedButton(
        onPressed: action,
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical)),
            backgroundColor: isFilledButton ? WidgetStateProperty.all<Color>(isActive ? color : ApplicationColors.GREY_2)
                : WidgetStateProperty.all<Color>(Colors.white),
            shape: !noRadius! ? specificCornerRadius != null ?
            WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: specificCornerRadius!,
                    side: BorderSide(color: isFilledButton ? Colors.transparent : color, width: 2)
                )) :
            WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.LOW_RADIUS),
                  side: BorderSide(color: isFilledButton ? Colors.transparent : color, width: 2)
                )) : null
        ),
        child: !ApplicationLayout.isPhone ?
        //TEXT PRIORITY IF NOT PHONE
        text.isNotEmpty ?
        FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(text, style: TextStyle(fontSize: textSize, color: colorText, fontWeight: FontWeight.bold),)
        )
            : Tooltip(margin: EdgeInsets.only(bottom: 10), preferBelow: false, message: text, child: icon) :
        //ICON PRIORITY IF PHONE
        icon == null ?
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(text, style: TextStyle(fontSize: textSize, color: colorText, fontWeight: FontWeight.bold),)
      ) : Tooltip(margin: EdgeInsets.only(bottom: 10),preferBelow: false, message: text, child: icon)
      ),
    );
  }
}
