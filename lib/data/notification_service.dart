// import 'dart:developer';
// import 'dart:io';
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// class NotificationsServices {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//
//   static Future<void> initNotifications(BuildContext context) async {
//     getFcmDeviceToken();
//     await _requestPermission();
//     _configureForegroundNotifications(context: context);
//     _foregroundMessagesIOS();
//     _configureBackgroundNotifications();
//   }
//
//   static Future<void> _requestPermission() async {
//     final settings = await _messaging.requestPermission(alert: true, badge: true, sound: true);
//     log('User granted permission: ${settings.authorizationStatus}', name: 'Notification Permission');
//   }
//
//   static void _configureForegroundNotifications({required BuildContext context}) {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       log('Received a message in the foreground!', name: 'Foreground Notification');
//       log('Message data: ${message.notification}', name: 'Foreground Notification');
//       if (Platform.isIOS) return;
//       if (message.notification != null) {
//         log('Message also contained a notification: ${message.notification?.body}', name: 'Foreground Notification');
//       }
//     });
//   }
//
//   static void _configureBackgroundNotifications() {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       log('Received a message when the app was opened from background!', name: 'Background Notification');
//       log('Message data: ${message.data}', name: 'Background Notification');
//
//       if (message.notification != null) {
//         log('Message also contained a notification: ${message.notification}', name: 'Background Notification');
//       }
//     });
//   }
//
//   static Future<String?> getFcmDeviceToken() async {
//     String? token = await _messaging.getToken();
//     log("Fcm Token : $token", name: "FCM Token");
//     if (token != null) {
//       return token;
//     } else {
//       return null;
//     }
//   }
//
//   static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     await Firebase.initializeApp();
//
//     log("Handling a background message: ${message.messageId}");
//   }
//
//   static Future<void> _foregroundMessagesIOS() async {
//     _messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
//   }
// }
//
//

import 'dart:developer';
import 'dart:io';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../utils/const/colors.dart';
import '../utils/const/styles.dart';

// import '../utils/utils.dart';

class NotificationsServices {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initNotifications(BuildContext context) async {
    _messaging.subscribeToTopic('notification');
    getFcmDeviceToken();
    await _requestPermission();
    _configureForegroundNotifications(context: context);
    _foregroundMessagesIOS();
    _configureBackgroundNotifications();
  }

  static Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    log(
      'User granted permission: ${settings.authorizationStatus}',
      name: 'Notification Permission',
    );
  }

  static void _configureForegroundNotifications({
    required BuildContext context,
  }) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log(
        'Received a message in the foreground!',
        name: 'Foreground Notification',
      );
      log(
        'Message data: ${message.notification}',
        name: 'Foreground Notification',
      );
      if (Platform.isIOS) return;
      ElegantNotification(
        background: kYellowLightColor,
        width: MediaQuery.of(context).size.width * 0.92,
        position: Alignment.topCenter,
        animation: AnimationType.fromTop,
        stackedOptions: StackedOptions(
          key: 'top',
          type: StackedType.same,
          itemOffset: const Offset(-1, -6),
        ),
        title: Text(
          '${message.notification?.title}',
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        description: Text(
          '${message.notification?.body}',
          style: AppStyles.bodyMedium.copyWith(color: kTextColor),
        ),
        progressIndicatorColor: kPrimaryColor,
        onDismiss: () {},
      ).show(context);
      if (message.notification != null) {
        log(
          'Message also contained a notification: ${message.notification?.body}',
          name: 'Foreground Notification',
        );
      }
    });
  }

  static void _configureBackgroundNotifications() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log(
        'Received a message when the app was opened from background!',
        name: 'Background Notification',
      );
      log('Message data: ${message.data}', name: 'Background Notification');

      if (message.notification != null) {
        log(
          'Message also contained a notification: ${message.notification}',
          name: 'Background Notification',
        );
      }
    });
  }

  static Future<String?> getFcmDeviceToken() async {
    String? token = await _messaging.getToken();
    log("Fcm Token : $token", name: "FCM Token");
    if (token != null) {
      return token;
    } else {
      return null;
    }
  }

  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();

    log("Handling a background message: ${message.messageId}");
  }

  static Future<void> _foregroundMessagesIOS() async {
    _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
