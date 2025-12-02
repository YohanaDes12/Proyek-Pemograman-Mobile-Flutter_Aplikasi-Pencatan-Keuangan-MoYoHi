import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pin_screen.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cek apakah PIN sudah pernah dibuat?
  final prefs = await SharedPreferences.getInstance();
  final bool hasPin = prefs.containsKey('USER_PIN');

  runApp(MoneyUApp(startWithPinSetup: !hasPin));
}

class MoneyUApp extends StatelessWidget {
  final bool startWithPinSetup;
  const MoneyUApp({super.key, required this.startWithPinSetup});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.bluePrimary,
      ),
      // Jika belum punya PIN -> isSetup = true
      // Jika sudah punya PIN -> isSetup = false (Verifikasi)
      home: PinScreen(isSetup: startWithPinSetup),
    );
  }
}