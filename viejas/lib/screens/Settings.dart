import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:viejas/model/profile.dart';

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
    print('playerID: ${playerID}');
    var params = {'playerid': playerID};
    var url = Uri.parse(urlStr);
    var response = await http.post(
      url,
      body: convert.jsonEncode(params),
    );
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    final profile = profileFromJson(response.body);
    print('Response profilename: ${profile.first.name}');
    setState(() {
      user = profile.first;
    });
  }

  Future hitUpdateProfileAPI() async {
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
    String urlStr = Constants.updateprofileurl;
    String playerID = await UserManager.getPlayerId();

    var params = {
      'playerid': playerID,
      'push_notifications': 1,
      'track_location': 0,
      'biometric': 1
    };
    var url = Uri.parse(urlStr);
    var response = await http.post(
      url,
      body: convert.jsonEncode(params),
    );
    List resp = convert.jsonDecode(response.body);
    String alertMsg = "Something went wrong";
    String statusMsg = "Success";
    if (resp.length > 0) {
      alertMsg = resp[0]['message'];
      statusMsg = resp[0]['Status'];
    }
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      if (statusMsg == "Success") {
        Utils.showAndroidDialog(context, title: statusMsg, message: alertMsg,
            okCallback: () {
          Navigator.pop(context);
        });
      } else {
        Utils.showAndroidDialog(context, title: statusMsg, message: alertMsg);
      }
    } else {
      Utils.showAndroidDialog(context, title: statusMsg, message: alertMsg);
    }
  }

  @override
  void initState() {
    super.initState();
    hitGetProfileAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
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
            _buildButtonImage('Reset Password', () {}),
            _buildHeader(context, 'Permissions',
                'viejas uses the following permissions while you use this app.'),
            _buildButtonImage('Push Notifications', () {}),
            _buildButtonImage('Location', () {}),
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
                setState(() {
                  isBiometricON = newvalue;
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
            onPressed: onTap,
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
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
