import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/screens/tabspage.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;


const myTask = "syncWithTheBackEnd";

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
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print("Main func position is -> $position");
    hitTrackLocationAPI(position.latitude, position.longitude);
  } catch (e) {
    print('error -> $e');
    return Future.error(e);
  }
}

Future hitTrackLocationAPI(double latitude, double longitude) async {
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

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    switch (task) {
      case myTask:
        print("this method was called from native!");
        getCurrentLocation();
        break;
      case Workmanager.iOSBackgroundTask:
        print("iOS background fetch delegate ran");
        break;
    }
    return Future.value(true);
  });
}

void main() {
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerOneOffTask(
    "1",
    myTask, //This is the value that will be returned in the callbackDispatcher
    initialDelay: Duration(minutes: 3),
    // constraints: WorkManagerConstraintConfig(
    //   requiresCharging: true,
    //   networkType: NetworkType.connected,
    // ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print(
            'Location permissions are permanently denied, we cannot request permissions.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      // return position;
      print("position is -> $position");
    } catch (e) {
      print('error -> $e');
      return Future.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: TabsPage(selectedIndex: 0),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white //here you can give the text color
          ),
      primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Constants.appGrayBgColor,
      bottomAppBarColor: Colors.black,
      textTheme: TextTheme(
        bodyText1: TextStyle(),
        bodyText2: TextStyle(),
      ).apply(
        bodyColor: Colors.white,
      ),
    );
  }
}
