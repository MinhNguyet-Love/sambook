
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sambook/auth/auth_service.dart';
import 'package:sambook/screens/StoryGrid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final user = FirebaseAuth.instance.currentUser;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Thư viện"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await auth.signOut(context);
              },
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Truyện"),
              Tab(text: "Sách"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StoryGrid(type: "truyen"),
            StoryGrid(type: "sach"),
          ],
        ),
      ),
    );
  }
}
