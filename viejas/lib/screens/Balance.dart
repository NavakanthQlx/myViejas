import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'package:viejas/helpers/widgets.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:viejas/model/balance.dart';
import 'package:viejas/screens/SideMenu.dart';

class Balance extends StatefulWidget {
  const Balance({Key? key}) : super(key: key);

  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  bool isLoading = false;
  BalanceObject? user;

  getIsUserLoggedIn() async {
    var isUserLoggedIn = await UserManager.isUserLogin();
    if (isUserLoggedIn) {
      getBalaceDetails();
    }
  }

  Future getBalaceDetails() async {
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
    String urlStr = Constants.getBalanceUrl;
    //10047323
    String playerID = await UserManager.getPlayerId();
    print(urlStr);
    print('playerID: $playerID');
    var params = {'player_id': playerID};
    var url = Uri.parse(urlStr);
    var response = await http.post(
      url,
      body: convert.jsonEncode(params),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    final profile = balanceFromJson(response.body);
    setState(() {
      user = profile.first;
    });
  }

  @override
  void initState() {
    super.initState();
    getIsUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidemenu(),
      appBar: myAppBar(context: context),
      backgroundColor: Color.fromRGBO(40, 48, 51, 1),
      body: Container(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              height: 40,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Text(
                'Balance and Account Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // _buildRow('Comp Balance', user?.compBalance ?? ""),
            _buildRow('Redeemable Points', user?.redeemablePoints ?? ""),
            _buildRow('Tier Points', user?.tierPoints ?? ""),
            _buildRow('Current Tier', user?.currentTier ?? ""),
            _buildRow('Tier Expiration', user?.tierExpiration ?? ""),
          ],
        ),
      ),
    );
  }

  Container _buildRow(String title, String value) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title : ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            height: 5,
            padding: EdgeInsets.symmetric(horizontal: 100),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/line.png'), fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
