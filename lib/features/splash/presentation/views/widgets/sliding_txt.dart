import 'package:flutter/material.dart';
import 'package:wedding/core/utils/assets.dart';

class SlidingText extends StatelessWidget {
  const SlidingText({
    super.key,
    required this.slidingAnimation,
  });

  final Animation<Offset> slidingAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: slidingAnimation,
        builder: (context, _) {
          return SlideTransition(
            position: slidingAnimation,
            child: const Text(
              " just got a whole lot easier !",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20 ,
                  fontFamily: AssetsData.Dancing,
                  fontWeight: FontWeight.w400,
                color: Colors.white
              ),
            ),
          );
        });
  }
}