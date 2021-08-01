import 'package:blue_waves/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BWPasswordField extends StatefulWidget {
  const BWPasswordField({
    required this.labelText,
    this.emailController,
    this.obscureText = false,
    this.type,
    Key? key,
  }) : super(key: key);

  final TextEditingController? emailController;
  final String labelText;
  final bool obscureText;
  final TextInputType? type;

  @override
  _BWPasswordFieldState createState() => _BWPasswordFieldState();
}

class _BWPasswordFieldState extends State<BWPasswordField> {
  bool showingPassword = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0.h,
        horizontal: 20.w,
      ),
      child: TextField(
        autocorrect: false,
        obscureText: !showingPassword,
        controller: widget.emailController,
        keyboardType: widget.type,
        showCursor: true,
        decoration: InputDecoration(
          labelText: widget.labelText,
          suffixIcon: GestureDetector(
              onTap: () {
                log.i('holding');
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
                  : const Icon(Icons.visibility_off)),
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
