// To parse this JSON data, do
//
//     final diningList = diningListFromJson(jsonString);

import 'dart:convert';

// List<NotificationList> notificationListFromJson(String str) =>
//     List<NotificationList>.from(json.decode(str).map((x) => NotificationList.fromJson(x)));
//
// String notificationListToJson(List<NotificationList> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationHead {
  final List<NotificationList> users;
  NotificationHead({required this.users});
  factory NotificationHead.fromJson(List<dynamic> parsedJson) {
    List<NotificationList> users = [];
    users = parsedJson.map((i) => NotificationList.fromJson(i)).toList();
    return NotificationHead(users: users);
  }
}

class NotificationList {
  NotificationList({
    required this.notificationId,
    required this.message,
    required this.timings,
    required this.notificationReadStatus,
  });

  final String notificationId;
  final String message;
  final String timings;
  final String notificationReadStatus;

  factory NotificationList.fromJson(Map<String, dynamic> json) => NotificationList(
    notificationId: json["id"],
    message: json["message"],
    timings: json["sent_datetime"],
    notificationReadStatus: json["mark_as_read"],
  );

  Map<String, dynamic> toJson() => {
    "id": notificationId,
    "message": message,
    "sent_datetime": timings,
    "mark_as_read": notificationReadStatus,
  };
}
