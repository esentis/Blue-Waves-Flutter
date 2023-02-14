import 'package:blue_waves/constants.dart';
import 'package:blue_waves/states/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BWTextField extends StatefulWidget {
  const BWTextField({
    required this.labelText,
    this.controller,
    this.type,
    this.isPassword = false,
    this.obscureText,
    super.key,
  });

  final TextEditingController? controller;
  final String labelText;
  final TextInputType? type;
  final bool isPassword;
  final bool? obscureText;

  @override
  _BWTextFieldState createState() => _BWTextFieldState();
}

class _BWTextFieldState extends State<BWTextField> {
  bool showingPassword = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0.h,
        horizontal: 20.w,
      ),
      child: TextField(
        cursorColor: kColorBlueLight,
        autocorrect: false,
        obscureText: widget.obscureText ?? !showingPassword,
        controller: widget.controller,
        keyboardType: widget.type,
        showCursor: true,
        decoration: InputDecoration(
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!showingPassword) {
                        showingPassword = true;
                      } else {
                        showingPassword = false;
                      }
                    });
                  },
                  child: showingPassword
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                )
              : const SizedBox.shrink(),
          labelText: widget.labelText,
          labelStyle: kStyleDefault.copyWith(
            color: ThemeState.of(context, listen: true).isDark
                ? kColorOrangeLight!
                : kColorBlue,
            fontSize: 15.sp,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 20.w,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: kColorOrangeLight!,
              width: 1.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: kColorOrangeLight2!,
              width: 1.w,
            ),
          ),
        ),
        style: kStyleDefaultBold.copyWith(
          fontSize: 25.sp,
          color: kColorOrangeLight,
        ),
      ),
    );
  }
}
