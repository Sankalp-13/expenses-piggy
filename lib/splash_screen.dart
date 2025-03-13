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
          child: LottieBuilder.asset('assets/expense_splash.json'),
        )
      ],
    ), nextScreen: AnimatedGradientBackground(child: ExpenseTracker()),
    splashIconSize: 400,
    backgroundColor: Color(0xF3AAC4FF),);
  }
}
