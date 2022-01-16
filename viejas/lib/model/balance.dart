import 'package:meta/meta.dart';
import 'dart:convert';

List<BalanceObject> balanceFromJson(String str) => List<BalanceObject>.from(
    json.decode(str).map((x) => BalanceObject.fromJson(x)));

String balanceToJson(List<BalanceObject> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BalanceObject {
  BalanceObject({
    required this.compBalance,
    required this.redeemablePoints,
    required this.tierPoints,
    required this.currentTier,
    required this.tierExpiration,
  });

  final String compBalance;
  final String redeemablePoints;
  final String tierPoints;
  final String currentTier;
  final String tierExpiration;

  factory BalanceObject.fromJson(Map<String, dynamic> json) => BalanceObject(
        compBalance: json["comp_balance"],
        redeemablePoints: json["redeemable_points"],
        tierPoints: json["tier_points"],
        currentTier: json["current_tier"],
        tierExpiration: json["tier_expiration"],
      );

  Map<String, dynamic> toJson() => {
        "comp_balance": compBalance,
        "redeemable_points": redeemablePoints,
        "tier_points": tierPoints,
        "current_tier": currentTier,
        "tier_expiration": tierExpiration,
      };
}
