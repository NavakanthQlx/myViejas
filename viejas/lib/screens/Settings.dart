import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isBiometricON = true;

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
            _buildRow('Name', 'Gourish'),
            _buildRow('Username', 'Gourish'),
            _buildRow('Birthday', '12/05/1990'),
            _buildRow('Mobile Number', '999898227272'),
            _buildRow('Email', 'Gourish@gmail.com'),
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
                      fontSize: 19,
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
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 25,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
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
