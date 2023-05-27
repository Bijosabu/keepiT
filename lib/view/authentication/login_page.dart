import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:keepit/core/constants/constants.dart';
import 'package:keepit/model/services/google_auth_services.dart';
import 'package:keepit/view/widgets/main_button.dart';
// import 'package:keepit/view/widgets/main_button.dart';
import 'package:keepit/view/widgets/main_text_field.dart';

class LoginPage extends StatelessWidget {
  final Function()? onTap;
  LoginPage({super.key, this.onTap});
  final userNameController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void showSnackbar(String message) {
      final snackbar = SnackBar(content: Text(message));

      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }

    void signInUser() async {
      try {
        showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userNameController.text,
          password: pwdController.text,
        );
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        print(e.toString());
        showSnackbar('Invalid username or password');
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Text(
                  "Keep It! ",
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                kHeight10,
                Icon(
                  Icons.lock_outline_rounded,
                  size: 60,
                  color: Colors.grey[800],
                ),
                kHeight20,
                MainTextField(
                  controller: userNameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                kHeight20,
                MainTextField(
                  controller: pwdController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                kHeight10,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                // Sign in Button
                kHeight20,
                // GestureDetector(
                //   onTap: () {
                //     signInUser();
                //   },
                //   child: Container(
                //     width: size.width - 60,
                //     height: 60,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Colors.blue[700],
                //     ),
                //     child: const Center(
                //       child: Text(
                //         'Sign in',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 15,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    signInUser();
                  },
                  child: const MainButton(text: 'Sign in'),
                ),
                kHeight10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        'or continue with',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                kHeight20,
                // Google sign in Button
                GestureDetector(
                  onTap: () => AuthService().signInWithGoogle(),
                  child: const GoogleWIdget(),
                ),
                kHeight20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: const Text(
                        'Register now ',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class GoogleWIdget extends StatelessWidget {
  const GoogleWIdget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200]),
          child: Image.asset(
            "assets/images/googleimage.webp",
            height: 70,
          ),
        ),
      ],
    );
  }
}
