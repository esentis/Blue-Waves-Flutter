import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Sun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Lottie.network(
      'https://assets10.lottiefiles.com/private_files/lf30_Um0Z9o.json',
      animate: true,
      repeat: true,
      width: 100,
    );
  }
}
