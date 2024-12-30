import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:power_bill/authentication/auth_phone.dart';
import 'package:power_bill/firebase_options.dart';
import 'package:power_bill/themes/dark_theme.dart';
import 'package:power_bill/themes/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightmode,
      darkTheme: darkmode,
      themeMode: ThemeMode.system,
      home: const PhoneAuthScreen(),
    );
  }
}
