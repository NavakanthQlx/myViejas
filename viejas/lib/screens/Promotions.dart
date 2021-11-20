import 'package:flutter/material.dart';
import 'package:viejas/screens/WebViewScreen.dart';

class Promotions extends StatefulWidget {
  const Promotions({Key? key}) : super(key: key);

  @override
  _PromotionsState createState() => _PromotionsState();
}

class _PromotionsState extends State<Promotions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
            itemCount: 20,
            itemBuilder: (contex, index) {
              if (index == 0) {
                return Container(
                  height: 280.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('images/temp.png'),
                    ),
                  ),
                );
              } else {
                return _buildPromotionCell();
              }
            }),
      ),
    );
  }

  Container _buildPromotionCell() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Row(
        children: [
          Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/temp.png'),
              ),
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PROMOTIONS',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WebViewScreen()),
                  );
                },
                child: Text(
                  'Get details of all promotions',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
