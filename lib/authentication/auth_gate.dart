import 'package:flutter/material.dart';
import 'package:power_bill/authentication/auth_phone.dart';
import 'package:power_bill/pages/home_router.dart';
import 'package:power_bill/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.currentUser == null) {
          return const PhoneAuthScreen(); // User not logged in
        }
        return const Home(); // User is logged in
      },
    );
  }
}
