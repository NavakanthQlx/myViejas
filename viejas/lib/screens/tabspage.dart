import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/screens/LoginScreen.dart';
import 'package:viejas/screens/bottom_tabs.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// ignore: must_be_immutable
class TabsPage extends StatefulWidget {
  int selectedIndex = 0;

  TabsPage({required this.selectedIndex});

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _selectedIndex = 0;
  var isUserLoggedIn = false;

  getIsUserLoggedIn() async {
    isUserLoggedIn = await UserManager.isUserLogin();
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 3 || index == 4) {
        getIsUserLoggedIn();
      }
      widget.selectedIndex = index;
      _selectedIndex = widget.selectedIndex;
      print(_selectedIndex);
    });
  }

  setupOneSignal() async {
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId("9a2fd449-7193-489a-a00d-689417ff0877");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.onesignaluserID, osUserID ?? "");
  }

  @override
  void initState() {
    _onItemTapped(widget.selectedIndex);
    super.initState();
    setupOneSignal();
    getIsUserLoggedIn();
  }

  Widget _buildBody() {
    if (isUserLoggedIn) {
      return _buildTabbarBody();
    } else {
      if (_selectedIndex == 3 || _selectedIndex == 4) {
        return LoginScreen();
      } else {
        return _buildTabbarBody();
      }
    }
  }

  Widget? _buildBottomBar() {
    if (isUserLoggedIn) {
      return _buildTabbar();
    } else {
      if (_selectedIndex == 3 || _selectedIndex == 4) {
        return null;
      } else {
        return _buildTabbar();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Tabpage -> $isUserLoggedIn');
    return Scaffold(
      body: Scaffold(
        body: _buildBody(),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  BottomNavigationBar _buildTabbar() {
    return BottomNavigationBar(
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
    );
  }

  IndexedStack _buildTabbarBody() {
    return IndexedStack(
      index: widget.selectedIndex,
      children: [
        for (final tabItem in TabNavigationItem.items) tabItem.page,
      ],
    );
  }
}
