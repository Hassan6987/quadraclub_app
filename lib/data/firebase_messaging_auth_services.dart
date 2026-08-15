import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class FirebaseMessagingAuthService {
  static Future<String?> getAccessToken() async {
    try {
      final serviceAccountJson = await rootBundle.loadString(
        'assets/firebase_service_account.json',
      );
      final credentials = auth.ServiceAccountCredentials.fromJson(
        serviceAccountJson,
      );
      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final client = await auth.clientViaServiceAccount(credentials, scopes);
      client.close();
      return client.credentials.accessToken.data;
    } catch (e) {
      log('Error getting access token: $e');
      return null;
    }
  }

  static Future<bool> sendNotification({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final accessToken = await getAccessToken();

      if (accessToken == null) {
        log('Failed to obtain access token');
        return false;
      }
      final projectId = 'znon-9396a';
      final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
      );
      final payload = {
        'message': {
          'token': token,
          'notification': {'title': title, 'body': body},
          'data': data ?? {},
        },
      };
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );
      log('Notification send status: ${response.statusCode}');
      log('Response body: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      log('Error sending notification: $e');
      return false;
    }
  }
}
