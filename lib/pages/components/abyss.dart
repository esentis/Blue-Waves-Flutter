import 'package:flutter/material.dart';

class Abyss extends StatelessWidget {
  const Abyss({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              const Color(0xff150485).withOpacity(0.5),
              const Color(0xff005295).withOpacity(0.5),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
