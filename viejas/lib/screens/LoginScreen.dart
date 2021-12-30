import 'package:flutter/material.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/screens/Signup.dart';
import 'package:viejas/helpers/utils.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _playerId = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  bool isLoading = false;

  Future hitLoginAPI() async {
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
    String urlStr = Constants.loginurl;
    var params = {
      'playerclubid': _playerId.text,
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

  Center _buildLoader() {
    return Center(
      child: SpinKitCircle(
        color: Colors.red,
        size: 50.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(),
        body: SingleChildScrollView(
          child: Stack(alignment: Alignment.center, children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 70, 15, 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      child: Image.asset('images/Logo.png', fit: BoxFit.fill),
                    ),
                    _buildTextField(_playerId, false, 'username'),
                    SizedBox(height: 15),
                    _buildTextField(_password, false, 'password'),
                    _buildSigninButton(context),
                    _buildForgetPassword(),
                    SizedBox(height: 25),
                    _buildSignup(),
                  ],
                ),
              ),
            ),
            isLoading ? _buildLoader() : Text(''),
          ]),
        ));
  }

  Row _buildSignup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {},
          child: Text(
            'Need a mobile app account?',
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                color: Colors.white),
          ),
        ),
        SizedBox(
          width: 7,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Signup()),
            );
          },
          child: Text(
            'Signup',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  InkWell _buildForgetPassword() {
    return InkWell(
      onTap: () {},
      child: Text(
        'Forget Password',
        style: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 15, color: Colors.white),
      ),
    );
  }

  performValidations() {
    if (_playerId.text.isEmpty) {
      Utils.showAndroidDialog(context, message: 'Please enter username');
      return;
    }
    if (_password.text.isEmpty) {
      Utils.showAndroidDialog(context, message: 'Please enter password');
      return;
    }
    hitLoginAPI();
  }

  Container _buildSigninButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      width: 100,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          performValidations();
        },
        child: const Text(
          'Sign In',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.white),
      ),
    );
  }

  Container _buildTextField(TextEditingController controller, bool isObscure,
      String placeholderText) {
    return Container(
      height: 40,
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: isObscure,
          textAlign: TextAlign.center,
          cursorColor: Colors.black,
          style: const TextStyle(
              fontWeight: FontWeight.normal, fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
            hintText: placeholderText,
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
      ),
    );
  }
}
