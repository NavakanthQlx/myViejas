import 'package:flutter/material.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _playerId = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _zipcode = new TextEditingController();
  bool checkedValue = false;
  bool isViejasChecked = false;
  DateTime? _chosenDateTime;
  bool isLoading = false;

  Future hitSignupAPI() async {
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
    String urlStr = Constants.signupurl;
    var params = {
      'playerclubid': _playerId.text,
      'dob': DateFormat('yyyy-MM-dd').format(_chosenDateTime ?? DateTime.now()),
      'zipcode': _zipcode.text,
      'emailaddress': _email.text
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

  Future<void> _showAndroidStyleDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990, 8),
        lastDate: DateTime.now());
    if (picked != null)
      setState(() {
        _chosenDateTime = picked;
      });
  }

  Container _buildCreateAccountButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          performValidations();
        },
        child: const Text(
          'Create Account',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            primary: Colors.red, shape: StadiumBorder()),
      ),
    );
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
    if (_playerId.text.isEmpty) {
      Utils.showAndroidDialog(context, message: 'Please enter Member ID');
      return;
    }
    if (_email.text.isEmpty) {
      Utils.showAndroidDialog(context, message: 'Please enter email address');
      return;
    }

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email.text);
    if (!emailValid) {
      Utils.showAndroidDialog(context,
          message: 'Please enter valid email address');
      return;
    }

    if (_chosenDateTime == null) {
      Utils.showAndroidDialog(context, message: 'Please enter date of Birth');
      return;
    }

    if (_zipcode.text.isEmpty) {
      Utils.showAndroidDialog(context, message: 'Please enter Zipcode');
      return;
    }

    if (!checkedValue) {
      Utils.showAndroidDialog(context, message: 'Please agree age');
      return;
    }

    if (!isViejasChecked) {
      Utils.showAndroidDialog(context,
          message: 'Please agree Viejas Casino & Resort or not');
      return;
    }

    hitSignupAPI();
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
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
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
                            Text(
                              'Have your Member Card but cant login ? Create an online account by entering your information below',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 17,
                                  color: Colors.black54),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _buildTFTitle('Member #:'),
                            _buildTextField(
                                _playerId, TextInputType.emailAddress),
                            _buildTFTitle('Email Address:'),
                            _buildTextField(_email, TextInputType.emailAddress),
                            _buildTFTitle('Date of Birth:'),
                            _buildDateOfBirthButton(context),
                            _buildTFTitle('Zipcode:'),
                            _buildTextField(_zipcode, TextInputType.phone),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.all(0),
                              activeColor: Colors.black,
                              checkColor: Colors.white,
                              title: Text(
                                  "I certify that i am 21 years of age or older."),
                              value: checkedValue,
                              onChanged: (newValue) {
                                setState(() {
                                  checkedValue = newValue ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.all(0),
                              activeColor: Colors.black,
                              checkColor: Colors.white,
                              title: Text(
                                  "I am not on the Viejas Casino & Resort exclusion lists."),
                              value: isViejasChecked,
                              onChanged: (newValue) {
                                setState(() {
                                  isViejasChecked = newValue ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            _buildCreateAccountButton(context),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
              isLoading ? _buildLoader() : Text(''),
            ],
          ),
        ));
  }

  Container _buildDateOfBirthButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _showAndroidStyleDatePicker(context);
          });
        },
        child: Text(
          _chosenDateTime == null
              ? ''
              : DateFormat('yyyy-MM-dd')
                  .format(_chosenDateTime ?? DateTime.now()),
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 0,
            alignment: Alignment.centerLeft),
      ),
    );
  }

  Text _buildTFTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.normal, fontSize: 20, color: Colors.black),
    );
  }

  Container _buildSignupContainer() {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'SIGN UP',
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 25, color: Colors.white),
        ),
      ),
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
