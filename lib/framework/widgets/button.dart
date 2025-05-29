import 'package:flutter/material.dart';
import 'package:taskly/framework/business/task_state.dart';
import 'package:taskly/framework/constants/app_style.dart';
import 'package:taskly/framework/constants/app_utils.dart';
import 'package:taskly/framework/models/task.dart';

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
    this.margin,
    this.isIconLeading = false,
    this.isIconTrailing = false,
    this.isIconOnly = false,
    this.buttonState
  });

  final Color color;
  final String text;
  final VoidCallback? action;
  final bool isFilledButton;
  final Color colorText;
  final double textSize;
  final double height;
  final Icon? icon;
  final BorderRadius? specificCornerRadius;
  final bool? noRadius;
  final double paddingHorizontal;
  final double paddingVertical;
  final double? width;
  final EdgeInsets? margin;
  final bool isIconLeading;
  final bool isIconTrailing;
  final bool isIconOnly;
  final TaskState? buttonState;

  @override
  Widget build(BuildContext context) {
    final isActive = action != null;

    Widget buildContent() {
      if (isIconOnly && icon != null) {
        return Tooltip(
          margin: EdgeInsets.only(bottom: 10),
          preferBelow: false,
          message: text,
          child: icon,
        );
      }

      final textWidget = Text(
        text,
        style: TextStyle(fontSize: textSize, color: colorText, fontWeight: FontWeight.bold),
      );

      if (icon == null) {
        return textWidget;
      }

      final iconWidget = Tooltip(
        margin: EdgeInsets.only(bottom: 10),
        preferBelow: false,
        message: text,
        child: icon,
      );

      if (isIconLeading) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [iconWidget, SizedBox(width: 8), textWidget],
        );
      } else if (isIconTrailing) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [textWidget, SizedBox(width: 8), iconWidget],
        );
      }

      return textWidget;
    }

    return Container(
      height: height,
      width: width,
      margin: margin,
      child: ElevatedButton(
        onPressed: action,
        style: ButtonStyle(
          padding: WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical)),
            backgroundColor: WidgetStatePropertyAll<Color>(
              buttonState is TaskLoading
                ? color
                : (isFilledButton ? (isActive ? color : ApplicationColors.GREY_2) : Colors.white)),
          shape: !noRadius!
              ? specificCornerRadius != null
                  ? WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: specificCornerRadius!,
                          side: BorderSide(color: isFilledButton ? Colors.transparent : color, width: 2)))
                  : WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.LOW_RADIUS),
                          side: BorderSide(color: isFilledButton ? Colors.transparent : color, width: 2)))
              : null,
        ),
        child: buttonState is TaskLoading
  ? SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        backgroundColor: color,
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(colorText),
      ),
    )
  : buildContent(),

      ),
    );
  }
}
