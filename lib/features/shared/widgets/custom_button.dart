import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/theme/theme.dart';

import 'ui_utils.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final VoidCallback onPressed;
  final bool? disabled;
  final String? buttonTitle;
  final double? fontSize;
  final Color? color;
  final String? icon;
  final double? iconSize;
  final Color? textColor;

  const CustomButton({
    super.key,
    this.height,
    this.width,
    this.disabled,
    this.fontSize,
    this.color,
    this.icon,
    this.buttonTitle,
    this.iconSize,
    this.textColor,
    required this.onPressed,
  });

  static void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: width ?? double.infinity,
      height: height ?? 56.rh(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.5,
      color: color,
      disabledColor: const Color.fromARGB(255, 214, 214, 214),
      onPressed: (disabled != true)
          ? () {
              unfocus();
              onPressed.call();
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: UiUtils.getSvg(icon!,
                    color: Colors.white, width: iconSize ?? 25.rf(context))),
          if (buttonTitle != null)
            Text(
              buttonTitle!,
              style: TextStyle(
                  color: textColor ?? Colors.black,
                  fontSize: fontSize ?? 16.rf(context)),
            )
        ],
      ),
    );
  }
}
