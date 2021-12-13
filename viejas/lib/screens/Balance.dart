import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:viejas/screens/SideMenu.dart';

class Balance extends StatefulWidget {
  const Balance({Key? key}) : super(key: key);

  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidemenu(),
      appBar: myAppBar(),
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
            _buildRow('Comp Balance', '0'),
            _buildRow('Redeemable Points', '0'),
            _buildRow('Tier Points', '85'),
            _buildRow('Current Tier', 'BRONZE'),
            _buildRow('Tier Expiration', '--'),
          ],
        ),
      ),
    );
  }

  Container _buildRow(String title, String value) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Row(
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
    );
  }
}
