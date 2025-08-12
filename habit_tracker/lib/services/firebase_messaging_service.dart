// lib/services/firebase_messaging_service.dart

import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';

// This new service handles all Firebase Cloud Messaging logic.
class FirebaseMessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // Request permission for iOS devices
    await _firebaseMessaging.requestPermission();

    // Get the device token. This is needed to send notifications to this device.
    final fcmToken = await _firebaseMessaging.getToken();
    log('FCM Token: $fcmToken');

    // Here you would typically send this token to your backend (Firestore, etc.)
    // and associate it with the logged-in user.

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
        // You can display a local notification here using a package like flutter_local_notifications.
      }
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    log('Handling a background message: ${message.messageId}');
  }
}
