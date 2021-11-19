import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.black,
            scaffoldBackgroundColor: Colors.black,
            bottomAppBarColor: Colors.black),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Home'),
          ),
          drawer: Drawer(
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {},
                      leading: ImageIcon(
                        AssetImage("images/Home.png"),
                        color: Colors.grey,
                        size: 30,
                      ),
                      title: Text(
                        'Home',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: new Theme(
            data: Theme.of(context).copyWith(
                // sets the background color of the `BottomNavigationBar`
                canvasColor: Colors.black,
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: Colors.red,
                textTheme: Theme.of(context).textTheme.copyWith(
                    caption: new TextStyle(
                        color: Colors
                            .white))), // sets the inactive color of the `BottomNavigationBar`
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("images/Home.png"),
                  ),
                  label: 'HOME',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("images/Map.png"),
                  ),
                  label: 'MAP',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("images/Promotions.png"),
                  ),
                  label: 'PROMOTIONS',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("images/Offers.png"),
                  ),
                  label: 'OFFERS',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("images/Balance.png"),
                  ),
                  label: 'BALANCE',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.white,
              showUnselectedLabels: true,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              onTap: (index) {
                print(index);
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ));
  }
}
