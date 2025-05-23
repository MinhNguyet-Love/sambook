// import 'dart:developer';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sambook/auth/login_screen.dart';
// import 'package:sambook/screens/StoryGrid.dart'; // 👉 Màn hình sau đăng nhập
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   /// Đăng nhập bằng Google
//   Future<UserCredential?> loginWithGoogle(BuildContext context) async {
//     try {
//       final googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) {
//         log("Google Sign-In bị hủy");
//         return null;
//       }
//
//       final googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//         accessToken: googleAuth.accessToken,
//       );
//
//       final userCredential = await _auth.signInWithCredential(credential);
//
//       if (userCredential.user != null) {
//         log("Đăng nhập thành công: ${userCredential.user!.email}");
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const StoryScreen()),
//         );
//       }
//       return userCredential;
//     } catch (e) {
//       log("Lỗi đăng nhập Google: $e");
//     }
//     return null;
//   }
//
//   /// Đăng nhập với Email & Password
//   Future<User?> loginUserWithEmailAndPassword(String email, String password, BuildContext context) async {
//     try {
//       final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
//       if (cred.user != null) {
//         log("User Logged In");
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const StoryScreen()),
//         );
//       }
//       return cred.user;
//     } catch (e) {
//       log("Lỗi đăng nhập: $e");
//     }
//     return null;
//   }
//
//   /// Đăng ký tài khoản với Email & Password
//   Future<User?> createUserWithEmailAndPassword(String email, String password) async {
//     try {
//       final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       return cred.user;
//     } catch (e) {
//       log("Lỗi tạo tài khoản: $e");
//     }
//     return null;
//   }
//
//   /// Đăng xuất
//   Future<void> signOut(BuildContext context) async {
//     try {
//       await _auth.signOut();
//       await GoogleSignIn().signOut();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//     } catch (e) {
//       log("Lỗi đăng xuất: $e");
//     }
//   }
// }
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sambook/auth/login_screen.dart';
import 'package:sambook/screens/MainTabScreen.dart'; // 👉 Dùng MainTabScreen thay vì StoryScreen

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Đăng nhập bằng Google
  Future<UserCredential?> loginWithGoogle(BuildContext context) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        log("Google Sign-In bị hủy");
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        log("Đăng nhập thành công: ${userCredential.user!.email}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainTabScreen()),
        );
      }
      return userCredential;
    } catch (e) {
      log("Lỗi đăng nhập Google: $e");
    }
    return null;
  }

  /// Đăng nhập với Email & Password
  Future<User?> loginUserWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (cred.user != null) {
        log("User Logged In");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainTabScreen()),
        );
      }
      return cred.user;
    } catch (e) {
      log("Lỗi đăng nhập: $e");
    }
    return null;
  }

  /// Đăng ký tài khoản với Email & Password
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Lỗi tạo tài khoản: $e");
    }
    return null;
  }

  /// Đăng xuất
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      log("Lỗi đăng xuất: $e");
    }
  }
}
