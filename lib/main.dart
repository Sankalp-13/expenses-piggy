import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expenses/splash_screen.dart';
import 'package:expenses/theme.dart';
import 'package:expenses/widgets/home_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('payment_modes');
  await Hive.openBox('expenses');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: pastelTheme,
      home: SplashScreen(),
    );
  }
}

