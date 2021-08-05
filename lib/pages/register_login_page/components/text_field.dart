import 'package:blue_waves/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BWTextField extends StatelessWidget {
  const BWTextField({
    required this.labelText,
    this.emailController,
    this.type,
    Key? key,
  }) : super(key: key);

  final TextEditingController? emailController;
  final String labelText;
  final TextInputType? type;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0.h,
        horizontal: 20.w,
      ),
      child: TextField(
        autocorrect: false,
        controller: emailController,
        keyboardType: type,
        showCursor: true,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: kStyleDefaultBold.copyWith(
            fontSize: 26.sp,
            color: Colors.orange[50]!.withOpacity(0.4),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 20.w,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: Colors.orange[50]!,
              width: 2.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: Colors.orange[200]!,
              width: 2.w,
            ),
          ),
        ),
        style: kStyleDefaultBold.copyWith(
          fontSize: 25.sp,
          color: Colors.orange[50],
        ),
      ),
    );
  }
}
