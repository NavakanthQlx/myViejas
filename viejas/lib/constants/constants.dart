import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';

class Constants {
  static const Color appGrayBgColor = Color.fromRGBO(40, 48, 51, 1);
  static const baseurl = "https://myviejasrewards.com/php/webservices/";//"http://casinovizion.com/viejasapp/webservices/";
  static const loadCasino = Constants.baseurl + "loadcasinoinfobyid.php?";
  static const loadpromotionlist = Constants.baseurl + "loadpromotionlist.php?";
  static const loaddinelist = Constants.baseurl + "loaddinelist.php?";
  static const loadeventlist = Constants.baseurl + "loadeventlist.php?";
  static const loginurl = Constants.baseurl +"login.php";//"https://qlx.com/viejas/php/webservices/login.php";
  static const signupurl =
      Constants.baseurl +"register.php";//"https://qlx.com/viejas/php/webservices/register.php";
  // static const forgotpasswordurl =
  //     Constants.baseurl +"send_password.php";
  static const forgotpasswordurl = Constants.baseurl +"forgot_password.php";
  static const changepasswordurl = Constants.baseurl +"change_password.php";//https://www.myviejasrewards.com/php/webservices/change_password.php
  static const getprofileurl =
      Constants.baseurl + "get_profile.php";//"https://qlx.com/viejas/php/webservices/get_profile.php";
  static const updateprofileurl =
      Constants.baseurl + "update_profile.php";//"https://qlx.com/viejas/php/webservices/update_profile.php";
  static const notificationURL = Constants.baseurl + "load_notifications.php?";

  static const getDiningUrl = Constants.baseurl + "loadvenueslist.php";
  static const getDiningDetailUrl = Constants.baseurl + "loadvenue_by_id.php";
  static const getMyViejaslUrl = Constants.baseurl + "loadcasinosinfo.php";
  static const getMusicLoungesUrl =
      Constants.baseurl + "loadentertainmentlist.php";
  static const getViejasOutletUrl = Constants.baseurl + "loadoutletinfo.php";
  static const getBalanceUrl = Constants.baseurl + "load_balance.php";
  static const getGamingUrl = Constants.baseurl + "loadgaminginfo.php";
  static const getGamingDetailUrl =
      Constants.baseurl + "loadgaminginfo_options.php";
  static const getContactusUrl = Constants.baseurl + "loadcontactusinfo.php";
  static const getHotelsURL = Constants.baseurl + "loadhotelsinfo.php";
  static const getOffersURL = Constants.baseurl + "load_offers.php";

  static const userID = "userid";
  static const accountID = "accountnumber";
  static const userName = "username";
  static const tier = "tier";
  static const points = "points";
  static const casinoId = "casinoId";
  static const isBioOn = "isBioOn";

  static const onesignaluserID = "onesignaluserid";
  String userDeviceID = "deviceID";
}

class UserManager {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  static Future<bool> isUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString(Constants.userID) ?? "";
    if (userid == "") {
      return false;
    }
    return true;
  }

  static Future<String> getPlayerId() async {
    final prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString(Constants.userID) ?? "";
    return userid;
  }

  static Future<String> getCasinoId() async {
    return "30";
    // final prefs = await SharedPreferences.getInstance();
    // String casinoId = prefs.getString(Constants.casinoId) ?? "";
    // return casinoId;
  }

  static Future<List<String>> getUserObj() async {
    final prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString(Constants.userID) ?? "";
    String userName = prefs.getString(Constants.userName) ?? "";
    String tier = prefs.getString(Constants.tier) ?? "";
    String points = prefs.getString(Constants.points) ?? "";
    String accountNumber = prefs.getString(Constants.accountID) ?? "";
    return [userid, userName, tier, points, accountNumber];
  }

  static Future<String> getOneSignalId() async {
    final prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString(Constants.onesignaluserID) ?? "";
    return userid;
  }

  static Future<String> getDeviceId() async {
    var deviceName;
    var deviceVersion;
    var identifier;

    Map<String, dynamic> deviceData = <String, dynamic>{};
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId;  //UUID for Android
      } else if (Platform.isIOS) {
        var build = await deviceInfoPlugin.iosInfo;
        deviceName = build.name;
        deviceVersion = build.systemVersion;
        identifier = build.identifierForVendor;  //UUID for iOS
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    // if (!mounted) return;
    // final prefs = await SharedPreferences.getInstance();
    // String userid = prefs.getString(Constants.userDeviceID) ?? "";
    print('My Device ID ${identifier}');
    return identifier;
  }
}
