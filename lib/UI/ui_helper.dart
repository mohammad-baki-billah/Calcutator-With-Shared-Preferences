import 'package:flutter/material.dart';

class UiHelper {
  static Widget customButton({
    String? btnText,
    double? txtSize,
    IconData? icon,
    double? iconSize,
    double? height,
    double? width,
    Color? color,
    Color? textColor,
    BoxShape shape = BoxShape.rectangle,
    required VoidCallback onPressed,
  }) {
    return Material(
      elevation: 5,
      borderRadius: shape == BoxShape.rectangle
          ? BorderRadius.circular(16)
          : null, // Remove borderRadius for oval buttons
      child: InkWell(
        onTap: onPressed,
        borderRadius:
            shape == BoxShape.rectangle ? BorderRadius.circular(16) : null,
        child: Container(
          height: height ?? 62,
          width: width ?? 62,
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            shape: shape,
            borderRadius:
                shape == BoxShape.rectangle ? BorderRadius.circular(16) : null,
          ),
          child: Center(
            child: icon != null
                ? Icon(
                    icon,
                    size: iconSize ?? 24,
                    color: Colors.black,
                  )
                : Text(
                    btnText ?? '',
                    style: TextStyle(
                      fontSize: txtSize ?? 32,
                      color:textColor?? Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
