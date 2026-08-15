// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:quadraclub_app/data/base_api_service.dart';
// import 'package:quadraclub_app/data/storage_service.dart';
// import 'package:quadraclub_app/presentation/home/data/notification_model.dart';
//
// import '../../../../di/locator.dart';
// import '../../../../utils/components/blue_app_bar.dart';
// import '../../../../utils/const/colors.dart';
//
// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//   late Future<List<NotificationModel>?> notificationsFuture;
//   final BaseApiProvider apiClient = BaseApiProvider();
//   final StorageService storageService = locator.get<StorageService>();
//
//   @override
//   void initState() {
//     super.initState();
//     notificationsFuture = getNotifications();
//   }
//
//   Future<List<NotificationModel>?> getNotifications() async {
//     const String url = "/api/notification/";
//
//     try {
//       final token = storageService.getToken();
//       final response = await apiClient.dio.get(
//         url,
//         options: Options(
//           headers: {
//             "Content-Type": "application/json",
//             "Accept": "application/json",
//             "Authorization": "Bearer $token",
//           },
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         final List data = response.data;
//         return data.map((n) => NotificationModel.fromJson(n)).toList();
//       }
//       return [];
//     } catch (e) {
//       throw Exception("Failed to load notifications: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BlueAppBar(
//         // height: 100,
//         title: "Notifications",
//         showBackArrow: true,
//       ),
//       body: FutureBuilder<List<NotificationModel>?>(
//         future: notificationsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No notifications found."));
//           } else {
//             final notifications = snapshot.data!;
//             return ListView.separated(
//               itemCount: notifications.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 8),
//               padding: const EdgeInsets.all(12),
//               itemBuilder: (context, index) {
//                 final notification = notifications[index];
//                 return Card(
//                   color: kSecondaryColor.withValues(alpha: 0.6),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 3,
//                   shadowColor: Colors.grey.withValues(alpha: 0.3),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.symmetric(
//                       vertical: 12,
//                       horizontal: 16,
//                     ),
//                     title: Text(
//                       notification.title,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     subtitle: Padding(
//                       padding: const EdgeInsets.only(top: 6),
//                       child: Text(
//                         notification.content,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                     trailing: notification.createdAt != null
//                         ? Text(
//                             "${notification.createdAt!.day}/${notification.createdAt!.month}/${notification.createdAt!.year}",
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: kPrimaryColor,
//                             ),
//                           )
//                         : null,
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
