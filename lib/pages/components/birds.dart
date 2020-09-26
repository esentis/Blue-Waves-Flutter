import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Birds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Lottie.network(
      'https://assets7.lottiefiles.com/packages/lf20_k6GHT3.json',
      animate: true,
      repeat: true,
      width: 250,
    );
  }
}
