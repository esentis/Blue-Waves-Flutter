import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({
    required this.isBeachFavorited,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final bool isBeachFavorited;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        depth: isBeachFavorited ? 15 : -25,
        intensity: 5,
        boxShape: const NeumorphicBoxShape.circle(),
        shadowDarkColor: Colors.red[500]!.withOpacity(0.5),
        shadowLightColor: Colors.orange[50],
        color: Colors.orange[50],
      ),
      onPressed: onTap as void Function()?,
      child: isBeachFavorited
          ? NeumorphicIcon(
              Icons.favorite,
              style: NeumorphicStyle(
                depth: 15,
                color: Colors.red[500],
                intensity: 5,
                shadowDarkColor: Colors.red[500]!.withOpacity(0.5),
                border: NeumorphicBorder(
                  color: Colors.orange[50]!.withOpacity(0.2),
                  width: 2,
                ),
              ),
              size: 22,
            )
          : NeumorphicIcon(
              Icons.favorite,
              size: 22,
              style: NeumorphicStyle(
                depth: 15,
                color: Colors.orange[50],
                border: NeumorphicBorder(
                  color: Colors.red[400]!.withOpacity(0.2),
                  width: 2,
                ),
              ),
            ),
    );
  }
}
