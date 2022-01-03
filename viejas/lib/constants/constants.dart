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

  static final String interviewurl =
      'https://interview-e18de.firebaseio.com/media.json?print=pretty';

  static const userID = "userid";
  static const onesignaluserID = "userid";
}
