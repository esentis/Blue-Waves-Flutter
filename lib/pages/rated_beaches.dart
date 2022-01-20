import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/pages/components/animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatedBeaches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.blue,
            size: 40,
          ),
        ),
        backgroundColor: Colors.orange[50]!.withOpacity(0.8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        centerTitle: true,
        title: Text(
          S.current.ratedBeaches,
          style: kStyleDefault.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      body: Stack(
        children: [
          const AnimatedBackground(
            showTitle: false,
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ],
      ),
    );
  }
}
