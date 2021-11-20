import 'package:flutter/material.dart';
import 'package:viejas/screens/CommonDetail.dart';
import 'package:viejas/screens/WebViewScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildHeaderImage() {
    return Stack(alignment: Alignment.bottomCenter, children: [
      Container(
        height: 230.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('images/temp.png'),
          ),
        ),
      ),
      Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 110,
        width: MediaQuery.of(context).size.width,
        color: Colors.black54,
        child: _buildLogoutView(),
      ),
    ]);
  }

  Row _buildLoginView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 25,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'TIER : BRONZE',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'POINTS : 100',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'My Offers',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
          ],
        )
      ],
    );
  }

  Row _buildLogoutView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Text(
            'See your special offers and rewards now!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            _buildHeaderImage(),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 3 / 3.7,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2),
                itemCount: 10,
                itemBuilder: (BuildContext ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommonDetailScreen()),
                      );
                    },
                    child: Center(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('images/temp2.png'),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black54,
                            child: Text(
                              'PROMOTIONS',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
