import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BWTextField extends StatelessWidget {
  const BWTextField({
    @required this.emailController,
    @required this.labelText,
    this.obscureText = false,
    Key key,
  }) : super(key: key);

  final TextEditingController emailController;
  final String labelText;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        autocorrect: false,
        obscureText: obscureText,
        controller: emailController,
        showCursor: true,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.adventPro(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.orange[50].withOpacity(0.4),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: BorderSide(
              color: Colors.orange[50],
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: BorderSide(
              color: Colors.orange[200],
              width: 2,
            ),
          ),
        ),
        style: GoogleFonts.adventPro(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.orange[50],
        ),
      ),
    );
  }
}
