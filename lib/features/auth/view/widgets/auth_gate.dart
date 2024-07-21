import 'package:expense_tracker/features/home/view/pages/dashboard_page.dart';
import 'package:expense_tracker/features/auth/view/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

//state persistance
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LoginPage();
          return Dashboard();
        });
  }
}
