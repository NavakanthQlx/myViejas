// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

List<Profile> profileFromJson(String str) =>
    List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));

String profileToJson(List<Profile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Profile {
  Profile({
    required this.name,
    required this.mobile,
    required this.email,
    required this.userName,
    required this.birthDate,
    required this.smsNotifications,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.trackLocation,
    required this.biometric,
  });

  final String name;
  final String mobile;
  final String email;
  final String userName;
  final String birthDate;
  final String smsNotifications;
  final String emailNotifications;
  final String pushNotifications;
  final String trackLocation;
  final String biometric;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        name: json["Name"],
        mobile: json["Mobile"],
        email: json["Email"],
        userName: json["UserName"],
        birthDate: json["BirthDate"],
        smsNotifications: json["sms_notifications"],
        emailNotifications: json["email_notifications"],
        pushNotifications: json["push_notifications"],
        trackLocation: json["track_location"],
        biometric: json["biometric"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Mobile": mobile,
        "Email": email,
        "UserName": userName,
        "BirthDate": birthDate,
        "sms_notifications": smsNotifications,
        "email_notifications": emailNotifications,
        "push_notifications": pushNotifications,
        "track_location": trackLocation,
        "biometric": biometric,
      };
}
