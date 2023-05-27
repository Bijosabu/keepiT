import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:keepit/core/constants/constants.dart';
import 'package:keepit/view/widgets/main_button.dart';
// import 'package:keepit/view/widgets/main_button.dart';
import 'package:keepit/view/widgets/main_text_field.dart';

class RegisterPage extends StatelessWidget {
  final Function()? onTap;
  RegisterPage({super.key, this.onTap});
  final userNameController = TextEditingController();
  final pwdController = TextEditingController();
  final confirmPwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // void showSnackbar(String message) {
    //   final snackbar = SnackBar(content: Text(message));

    //   ScaffoldMessenger.of(context).showSnackBar(snackbar);
    // }

    void signUpUser() async {
      try {
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return const Center(
        //       child: CircularProgressIndicator(),
        //     );
        //   },
        // );
        if (pwdController.text != confirmPwdController.text ||
            pwdController.text.length < 6) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Password Error'),
                content: const Text(
                  'Please make sure the passwords match and are at least 6 characters long.',
                  style: TextStyle(fontSize: 15),
                ),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: userNameController.text,
            password: pwdController.text,
          );
          Navigator.of(context).pop();
        }
        // Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        print(e.toString());
        // showSnackbar('Invalid username or password');
        // Navigator.of(context).pop();
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
                  height: 80,
                ),
                const Text(
                  'Create an account!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                kHeight10,
                const Icon(
                  Icons.create,
                  size: 40,
                ),
                const SizedBox(
                  height: 30,
                ),
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
                kHeight20,
                MainTextField(
                  controller: confirmPwdController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                kHeight10,
                kHeight20,
                //Sign up Button
                GestureDetector(
                  onTap: () {
                    signUpUser();
                  },
                  child: const MainButton(text: 'Sign up'),
                ),
                kHeight10,
                kHeight20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member? ',
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
                        'Login now ',
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
