import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static const Color appGrayBgColor = Color.fromRGBO(40, 48, 51, 1);
  static const baseurl = "http://casinovizion.com/viejasapp/webservices/";
  static const loadCasino = Constants.baseurl + "loadcasinoinfobyid.php?";
  static const loadpromotionlist = Constants.baseurl + "loadpromotionlist.php?";
  static const loaddinelist = Constants.baseurl + "loaddinelist.php?";
  static const loadeventlist = Constants.baseurl + "loadeventlist.php?";
  static const loginurl = "https://qlx.com/viejas/php/webservices/login.php";
  static const signupurl =
      "https://qlx.com/viejas/php/webservices/register.php";
  static const getprofileurl =
      "https://qlx.com/viejas/php/webservices/get_profile.php";
  static const updateprofileurl =
      "https://qlx.com/viejas/php/webservices/update_profile.php";

  //TODO:-
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

  static const userID = "userid";
  static const onesignaluserID = "onesignaluserid";
}

class UserManager {
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

  static Future<String> getOneSignalId() async {
    final prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString(Constants.onesignaluserID) ?? "";
    return userid;
  }
}
