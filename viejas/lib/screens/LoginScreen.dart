import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/local_auth_api.dart';
import 'package:viejas/helpers/user_secure_storage.dart';
import 'package:viejas/screens/Signup.dart';
import 'package:viejas/helpers/utils.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viejas/screens/forgetpassword.dart';
import 'package:viejas/screens/tabspage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _playerId = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  bool isLoading = false;
  late double latitude;
  late double longitude;

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      // return position;
      print("position is -> $position");
      latitude = position.latitude;
      longitude = position.longitude;
      print('Lat long is $latitude and $longitude');
      hitTrackLocationAPI();
    } catch (e) {
      print('error -> $e');
      return Future.error(e);
    }
  }

  Future hitTrackLocationAPI() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('connected');
    } else if (connectivityResult == ConnectivityResult.none) {
      // Utils.showToast('Please check your Internet Connection');
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    var playerId = prefs.getString(Constants.userID);
    String urlStr =
        "${Constants.baseurl}trackplayerlocation.php?player_id=$playerId&latitude=$latitude&longitude=$longitude";
    var response = await http.get(Uri.parse(urlStr));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

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
    var onesignalid = await UserManager.getOneSignalId();
    var params = {
      "username": _playerId.text,
      "password": _password.text,
      "device_id": "",
      "onesignal_id": onesignalid
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
        saveUserDatainDefaultsandKeychain(resp);
        getCurrentLocation();
        final prefs = await SharedPreferences.getInstance();
        var isBioON = prefs.getBool(Constants.isBioOn);
        if (isBioON != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TabsPage(selectedIndex: 0),
            ),
          );
        } else {
          Utils.showAndroidDialog(
            context,
            title: 'Biometric Login',
            message: 'Do you want to enable biometric login ?',
            oktitle: 'Yes',
            cancelTitle: 'No',
            showCancelButton: true,
            okCallback: () {
              prefs.setBool(Constants.isBioOn, true);
              setupTouchID(false);
            },
            cancelCallback: () {
              prefs.setBool(Constants.isBioOn, false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TabsPage(selectedIndex: 0),
                ),
              );
            },
          );
        }
      } else {
        Utils.showAndroidDialog(context, title: statusMsg, message: alertMsg);
      }
    } else {
      Utils.showAndroidDialog(context, title: statusMsg, message: alertMsg);
    }
  }

  Future<void> saveUserDatainDefaultsandKeychain(List<dynamic> resp) async {
    final prefs = await SharedPreferences.getInstance();
    String userId = resp[0]['player_id'];
    prefs.setString(Constants.userID, userId);

    String userName = resp[0]['Name'];
    prefs.setString(Constants.userName, userName);

    String tier = resp[0]['tier'];
    prefs.setString(Constants.tier, tier);

    String points = resp[0]['balance'];
    prefs.setString(Constants.points, points);

    await UserSecureStorage.setUsername(_playerId.text);
    await UserSecureStorage.setPassword(_password.text);
  }

  Center _buildLoader() {
    return Center(
      child: SpinKitCircle(
        color: Colors.red,
        size: 50.0,
      ),
    );
  }

  setupTouchID(bool isFromviewwillappear) async {
    final _auth = LocalAuthentication();
    try {
      final isAvailable = await _auth.canCheckBiometrics;
      if (!isAvailable) {
        showBioNotAvailablePopup();
        return;
      }
      try {
        final isSuccess = await _auth.authenticate(
            localizedReason: 'Scan Fingerprint to Authenticate',
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: false);
        if (isSuccess) {
          _playerId.text = await UserSecureStorage.getUsername() ?? '';
          _password.text = await UserSecureStorage.getPassword() ?? '';
          if (isFromviewwillappear) {
            hitLoginAPI();
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TabsPage(selectedIndex: 0),
              ),
            );
          }
        } else {
          Utils.showAndroidDialog(context, message: 'Authentication failed');
        }
      } on PlatformException catch (e) {
        print(e);
        Utils.showAndroidDialog(
          context,
          title: 'Authentication failed',
          message: "You could not be verified; please try again.",
          showCancelButton: false,
          okCallback: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TabsPage(selectedIndex: 0),
              ),
            );
          },
        );
        return;
      }
    } on PlatformException catch (e) {
      print(e);
      showBioNotAvailablePopup();
      return;
    }
  }

  showBioNotAvailablePopup() {
    Utils.showAndroidDialog(
      context,
      title: 'Biometry unavailable',
      message: "Your device is not configured for biometric authentication.",
      showCancelButton: false,
      okCallback: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TabsPage(selectedIndex: 0),
          ),
        );
      },
    );
  }

  callTouchIDbasedonBio() async {
    final prefs = await SharedPreferences.getInstance();
    var isBioON = prefs.getBool(Constants.isBioOn);
    if (isBioON == true) {
      setupTouchID(true);
    }
  }

  @override
  void initState() {
    super.initState();
    callTouchIDbasedonBio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/bg.png'), fit: BoxFit.cover),
            ),
          ),
          SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 150, 15, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          child:
                              Image.asset('images/Logo.png', fit: BoxFit.cover),
                        ),
                        _buildTextField(_playerId, false, 'username'),
                        SizedBox(height: 15),
                        _buildTextField(_password, true, 'password'),
                        _buildSigninButton(context),
                        _buildForgetPassword(),
                        SizedBox(height: 25),
                        _buildSignup(),
                      ],
                    ),
                  ),
                ),
                isLoading ? _buildLoader() : Text(''),
              ],
            ),
          ),
          Positioned(
            left: 20,
            top: 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Image.asset('images/Close.png'),
                iconSize: 35,
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TabsPage(selectedIndex: 0),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
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
                fontSize: 18,
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
              fontSize: 18,
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),
        );
      },
      child: Text(
        'Forgot Password',
        style: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 17, color: Colors.white),
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

  Column _buildTextField(TextEditingController controller, bool isObscure,
      String placeholderText) {
    return Column(
      children: [
        Container(
          height: 50,
          child: Center(
            child: TextField(
              controller: controller,
              obscureText: isObscure,
              textAlign: TextAlign.center,
              cursorColor: Colors.white38,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                  color: Colors.white),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                hintText: placeholderText,
                hintStyle: TextStyle(color: Colors.white60),
                fillColor: Colors.transparent,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Container(
          height: 5,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/line.png'), fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
