import 'package:flutter/material.dart';
import 'package:sambook/auth/auth_service.dart';
import 'package:sambook/auth/signup_screen.dart';
import 'package:sambook/widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscurePassword = true;

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
            const Text(
              "Login",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 50),

            // Email TextField
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Enter Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Password TextField with eye icon
            TextField(
              controller: _password,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Enter Password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Login button
            CustomButton(
              label: "Login",
              onPressed: () async {
                await _auth.loginUserWithEmailAndPassword(
                  _email.text,
                  _password.text,
                  context,
                );
              },
            ),
            const SizedBox(height: 10),

            // Google Sign-In button
            CustomButton(
              label: "Sign in with Google!",
              onPressed: () async {
                await _auth.loginWithGoogle(context);
              },
            ),
            const SizedBox(height: 5),

            // Signup link
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Don't have an account? "),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                ),
                child: const Text(
                  "Signup",
                  style: TextStyle(color: Colors.red),
                ),
              )
            ]),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
