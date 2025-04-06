import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:expenses/widgets/home_page.dart';

import 'animated_background.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  get splash=>null;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(splash: Column(
      children: [
        Center(
          child: Transform.translate(offset: Offset(5,0),
          child: LottieBuilder.asset('assets/expense_splash.json',width: 240,)),
        )
      ],
    ), nextScreen: AnimatedGradientBackground(child: ExpenseTracker()),
    splashIconSize: 255,
    duration: 1500,
    backgroundColor: Color(0xFFAAC4FF),);
  }
}
