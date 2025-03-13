import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expenses/splash_screen.dart';
import 'package:expenses/theme.dart';
import 'package:expenses/widgets/home_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('payment_modes');
  await Hive.openBox('expenses');

  const platform = MethodChannel('com.example.expenses/expense');

  // Handle method calls from the native side
  platform.setMethodCallHandler((call) async {
    if (call.method == 'addExpense') {
      final amount = call.arguments['amount'];
      final reason = call.arguments['reason'];
      final date = call.arguments['date'];

      // Add the expense to Hive
      await addExpenseToHive(amount, reason, date);
    }
  });
  runApp(MyApp());
}

Future<void> addExpenseToHive(String amount, String reason, String date) async {
  // Implement your Hive logic here
  // Example:
  print("*********HIVE********");
  print("AMOUNT: $amount , Reason: $reason, Date: $date");
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

