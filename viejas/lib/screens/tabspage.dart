import 'package:flutter/material.dart';
import 'package:viejas/screens/bottom_tabs.dart';

// ignore: must_be_immutable
class TabsPage extends StatefulWidget {
  int selectedIndex = 0;

  TabsPage({required this.selectedIndex});

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
      _selectedIndex = widget.selectedIndex;
      print(_selectedIndex);
    });
  }

  @override
  void initState() {
    _onItemTapped(widget.selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: IndexedStack(
          index: widget.selectedIndex,
          children: [
            for (final tabItem in TabNavigationItem.items) tabItem.page,
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
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
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: _onItemTapped,
      ),
    );
  }
}
