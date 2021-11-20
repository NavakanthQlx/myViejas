import 'package:flutter/material.dart';
import 'package:viejas/screens/WebViewScreen.dart';

class CommonDetailScreen extends StatefulWidget {
  const CommonDetailScreen({Key? key}) : super(key: key);

  @override
  _CommonDetailScreenState createState() => _CommonDetailScreenState();
}

class _CommonDetailScreenState extends State<CommonDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VIEJAS'),
      ),
      body: Container(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 20,
            itemBuilder: (contex, index) {
              if (index == 0) {
                return _buildHeaderImage();
              } else {
                return _buildPromotionCell();
              }
            }),
      ),
    );
  }

  Container _buildHeaderImage() {
    return Container(
      height: 280.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/temp.png'),
        ),
      ),
    );
  }

  Widget _buildPromotionCell() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WebViewScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Giner Noodle Bar',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Classic and contemporary Asian fare in a comfortable and modern setting Classic and contemporary Asian fare in a comfortable and modern setting',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        overflow: TextOverflow.visible,
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Colors.white70),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
