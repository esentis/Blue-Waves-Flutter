import 'package:Blue_Waves/connection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BWPasswordField extends StatefulWidget {
  const BWPasswordField({
    @required this.labelText,
    this.emailController,
    this.obscureText = false,
    this.type,
    Key key,
  }) : super(key: key);

  final TextEditingController emailController;
  final String labelText;
  final bool obscureText;
  final TextInputType type;

  @override
  _BWPasswordFieldState createState() => _BWPasswordFieldState();
}

class _BWPasswordFieldState extends State<BWPasswordField> {
  bool showingPassword = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: MediaQuery.of(context).size.width / 5,
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
                logger.i('holding');
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
          labelStyle: GoogleFonts.adventPro(
            fontSize: 26,
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
