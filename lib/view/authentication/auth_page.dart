import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keepit/view/authentication/login_or_register.dart';
import 'package:keepit/view/home/home_page.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // if user is already logged in
          if (snapshot.hasData) {
            return const HomePage();
          }
          // if user is not logged in
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
