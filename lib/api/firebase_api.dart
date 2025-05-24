//
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:sambook/main.dart';
//
// class FirebaseApi {
//
//   final _fisebaseMessaging = FirebaseMessaging.instance;
//   Future<void> iniNotifications() async {
//     await _fisebaseMessaging.requestPermission();
//     final fCMToken = await _fisebaseMessaging.getToken();
//     print("Token: $fCMToken");
//
//     initPusNotifications();
//   }
//
//
//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;
//     navigatorKey.currentState?.pushNamed(
//       '/notification_screen',
//       arguments: message,
//     );
//   }
//   Future initPusNotifications() async{
//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//   }
// }
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sambook/main.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // Yêu cầu quyền thông báo
    await _firebaseMessaging.requestPermission();

    // Lấy FCM token
    final fcmToken = await _firebaseMessaging.getToken();
    print("🔑 FCM Token: $fcmToken");

    // Khởi tạo lắng nghe thông báo
    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );
  }

  void initPushNotifications() {
    // Khi app bị kill và mở từ thông báo
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // Khi app đang chạy ngầm và người dùng bấm vào thông báo
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
