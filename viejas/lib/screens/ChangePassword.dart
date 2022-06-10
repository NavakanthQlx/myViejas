import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:viejas/screens/LoginScreen.dart';
import 'package:viejas/screens/PasswordSuccess.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _newPassword = new TextEditingController();
  // TextEditingController _email = new TextEditingController();
  TextEditingController _confirmPassword = new TextEditingController();
  bool isViejasChecked = false;
  DateTime? _chosenDateTime;
  bool isLoading = false;
  String userid = "test";

  Future<String> getPlayerId() async {
    final prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(Constants.accountID) ?? "";
    print('GetPlayerID in ForgotPassword:${userid}');
    return userid;
  }

  Future hitChangePasswordAPI() async {

    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => PasswordSuccessScreen()),
    //       (Route<dynamic> route) => false,
    // );
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
    String urlStr = Constants.changepasswordurl;
    var params = {
      'playerclubid': userid,
      'new_password': _confirmPassword.text,
    };
    var url = Uri.parse(urlStr);
    var response = await http.post(
      url,
      body: convert.jsonEncode(params),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
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
        Utils.showAndroidDialog(this.context, title: statusMsg, message: alertMsg,
            okCallback: () {
              // Navigator.pop(this.context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => PasswordSuccessScreen()),
                    (Route<dynamic> route) => false,
              );
            });
      } else {
        Utils.showAndroidDialog(this.context, title: statusMsg, message: alertMsg);
      }
    } else {
      Utils.showAndroidDialog(this.context, title: statusMsg, message: alertMsg);
    }
  }

  Container _buildResetPasswordButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          performValidations();
        },
        child: const Text(
          'Reset New Password',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            primary: Colors.red, shape: StadiumBorder()),
      ),
    );
  }

  Size screenSize() {
    return MediaQuery.of(context).size;
  }

  Center _buildLoader() {
    return Center(
      child: SpinKitCircle(
        color: Colors.red,
        size: 50.0,
      ),
    );
  }

  performValidations() {
    if (_newPassword.text.isEmpty) {
      Utils.showAndroidDialog(this.context, message: 'Please enter New Password');
      return;
    }

    if (_confirmPassword.text.isEmpty) {
      Utils.showAndroidDialog(this.context, message: 'Please enter Confirm Password');
      return;
    }
    if (_newPassword.text != _confirmPassword.text) {
      Utils.showAndroidDialog(this.context, message: 'Password and Confirm password must be same');
      return;
    }
    else{
      getPlayerId();
      hitChangePasswordAPI();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(),
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                // padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                width: screenSize().width,
                height: screenSize().height - 94,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSignupContainer(),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MEMBER LOYALTY',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.red),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'PROGRAM',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.red),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _buildTFTitle('New Password:'),
                            _buildTextField(
                                _newPassword, TextInputType.emailAddress),
                            _buildTFTitle('Confirm Password:'),
                            _buildTextField(_confirmPassword, TextInputType.emailAddress),
                            _buildResetPasswordButton(context),
                            SizedBox(height: 25),
                            _buildLogin(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isLoading ? _buildLoader() : Text(''),
            ],
          ),
        ));
  }

  Container _buildSignupContainer() {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'FORGOT PASSWORD',
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }

  Row _buildLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {},
          child: Text(
            'Already have an account?',
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                color: Colors.black),
          ),
        ),
        SizedBox(
          width: 7,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              this.context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text(
            'SignIn',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18,
              color: Colors.red,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Text _buildTFTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.normal, fontSize: 20, color: Colors.black),
    );
  }

  Container _buildTextField(
      TextEditingController controller, TextInputType textInputType) {
    return Container(
      height: 40,
      margin: EdgeInsets.fromLTRB(0, 13, 10, 13),
      child: TextField(
        keyboardType: textInputType,
        controller: controller,
        cursorColor: Colors.black,
        style: const TextStyle(
            fontWeight: FontWeight.normal, fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintStyle: TextStyle(color: Colors.black),
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
      ),
    );
  }
}