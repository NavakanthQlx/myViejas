import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:viejas/screens/LoginScreen.dart';

class PasswordSuccessScreen extends StatefulWidget {
  const PasswordSuccessScreen({Key? key}) : super(key: key);

  @override
  _PasswordSuccessScreenState createState() => _PasswordSuccessScreenState();
}

class _PasswordSuccessScreenState extends State<PasswordSuccessScreen> {
  bool isViejasChecked = false;
  bool isLoading = false;
  String _userid = "test";

   Future<String> getAccountId() async {
     final prefs = await SharedPreferences.getInstance();
     _userid = prefs.getString(Constants.accountID) ?? "";
     print('GetPlayerIDString:${_userid}');
     return _userid;
  }

  Size screenSize() {
    return MediaQuery
        .of(context)
        .size;
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
    getAccountId();
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
                      // _buildSignupContainer(),
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
                            Text(
                              'You have successfully reset your password.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'You will now be able to login to your account using your username and password.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                'Your username is:${_userid}',
                               style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                            ),
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
}