import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;

    return Scaffold(
      appBar: AppBar(title: const Text("📩 Thông báo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tiêu đề: ${message.notification?.title ?? 'Không có'}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text("Nội dung: ${message.notification?.body ?? 'Không có'}"),
            const SizedBox(height: 24),
            Text("Dữ liệu: ${message.data.toString()}"),
          ],
        ),
      ),
    );
  }
}
