// import 'dart:developer';

// import 'package:auth_firebase/auth/auth_service.dart';
// import 'package:auth_firebase/auth/signup_screen.dart';
// import 'package:auth_firebase/home_screen.dart';
// import 'package:auth_firebase/widgets/button.dart';
// import 'package:auth_firebase/widgets/textfield.dart';
// import 'package:flutter/material.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _auth = AuthService();

//   final _email = TextEditingController();
//   final _password = TextEditingController();

//   @override
//   void dispose() {
//     super.dispose();
//     _email.dispose();
//     _password.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 25),
//         child: Column(
//           children: [
//             const Spacer(),
//             const Text("Login",
//                 style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
//             const SizedBox(height: 50),
//             CustomTextField(
//               hint: "Enter Email",
//               label: "Email",
//               controller: _email,
//             ),
//             const SizedBox(height: 20),
//             CustomTextField(
//               hint: "Enter Password",
//               label: "Password",
//               controller: _password,
//             ),
//             const SizedBox(height: 30),
//             CustomButton(
//               label: "Login",
//               onPressed: _login,
//             ),
//             SizedBox(height: 10),
//             CustomButton(label: "Signin With Google!",
//             onPressed:() async {
//               await _auth.loginWithGoogle();
//             }
//             ),
//             const SizedBox(height: 5),
//             Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//               const Text("Already have an account? "),
//               InkWell(
//                 onTap: () => goToSignup(context),
//                 child:
//                     const Text("Signup", style: TextStyle(color: Colors.red)),
//               )
//             ]),
//             const Spacer()
//           ],
//         ),
//       ),
//     );
//   }

//   goToSignup(BuildContext context) => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const SignupScreen()),
//       );

//   goToHome(BuildContext context) => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const HomeScreen()),
//       );

//   _login() async {
//     final user =
//         await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);

//     if (user != null) {
//       log("User Logged In");
//       goToHome(context);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:sambook/auth/auth_service.dart';
import 'package:sambook/auth/signup_screen.dart';
import 'package:sambook/widgets/button.dart';
import 'package:sambook/widgets/textfield.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Spacer(),
            const Text("Login",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
            const SizedBox(height: 50),
            CustomTextField(
              hint: "Enter Email",
              label: "Email",
              controller: _email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Password",
              label: "Password",
              controller: _password,
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: "Login",
              onPressed: () async {
                await _auth.loginUserWithEmailAndPassword(
                    _email.text, _password.text, context);
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              label: "Sign in With Google!",
              onPressed: () async {
                await _auth.loginWithGoogle(context);
              },
            ),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Don't have an account? "),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                ),
                child: const Text("Signup", style: TextStyle(color: Colors.red)),
              )
            ]),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
