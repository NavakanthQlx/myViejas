import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'package:viejas/helpers/widgets.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:viejas/model/profile.dart';
import 'package:app_settings/app_settings.dart';
import 'package:viejas/screens/forgetpassword.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isBiometricON = true;
  bool isLoading = false;
  Profile? user;

  Future hitGetProfileAPI() async {
    final prefs = await SharedPreferences.getInstance();
    var isBioON = prefs.getBool(Constants.isBioOn);
    if (isBioON != null) {
      prefs.setBool(Constants.isBioOn, true);
      isBiometricON = isBioON;
    } else {
      prefs.setBool(Constants.isBioOn, false);
      isBiometricON = false;
    }
    setState(() {});
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('connected');
    } else if (connectivityResult == ConnectivityResult.none) {
      Utils.showToast('Please check your Internet Connection');
      return;
    }
    setState(() {
      isLoading = true;
    });
    String urlStr = Constants.getprofileurl;
    //10047323
    String playerID = await UserManager.getPlayerId();
    var params = {'player_id': playerID};
    var url = Uri.parse(urlStr);
    var response = await http.post(
      url,
      body: convert.jsonEncode(params),
    );
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    final profile = profileFromJson(response.body);
    // print('Response profilename: ${profile.first.name}');
    setState(() {
      user = profile.first;
    });
  }

  @override
  void initState() {
    super.initState();
    hitGetProfileAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildHeader(context, 'My Account',
                'To change your account information,please reach out to viejas'),
            _buildRow('Name', user?.name ?? ""),
            _buildRow('Username', user?.userName ?? ""),
            _buildRow('Birthday', user?.birthDate ?? ""),
            _buildRow('Mobile Number', user?.mobile ?? ""),
            _buildRow('Email', user?.email ?? ""),
            _buildButtonImage('Reset Password', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),
              );
            }),
            _buildHeader(context, 'Permissions',
                'viejas uses the following permissions while you use this app.'),
            _buildButtonImage('Push Notifications', () {
              AppSettings.openAppSettings();
            }),
            _buildButtonImage('Location', () {
              AppSettings.openLocationSettings();
            }),
            _buildswitch()
          ],
        ),
      ),
    );
  }

  Container _buildswitch() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Biometric Authentication',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          CupertinoSwitch(
              value: isBiometricON,
              onChanged: (newvalue) {
                setState(() async {
                  isBiometricON = newvalue;
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool(Constants.isBioOn, newvalue);
                });
              })
        ],
      ),
    );
  }

  Container _buildButtonImage(String title, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
      padding: EdgeInsets.all(0),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              onTap();
            },
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Image.asset(
                  "images/Arrow.png",
                  width: 20.0,
                  height: 20.0,
                )
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Container _buildRow(String title, String value) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 10, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$title : ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Container _buildHeader(BuildContext context, String title, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 90,
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
