import 'package:flutter/material.dart';
import '../helpers/widgets.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/notification.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  Future<dynamic> getDataFromAPI() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('connected');
    } else if (connectivityResult == ConnectivityResult.none) {
      Utils.showToast('Please check your Internet Connection');
      return [];
    }
    //1056471
    String playerID = await UserManager.getPlayerId();

    String urlStr = Constants.notificationURL;
    var params = {'player_id': playerID};
    var url = Uri.parse(urlStr);
    var response = await http.post(
      url,
      body: convert.jsonEncode(params),
    );
    var json = convert.jsonDecode(response.body);
    print('url -> $url');
    print('json -> $json');
    if (response.statusCode == 200) {
      var usersListArray = NotificationHead.fromJson(json);
      return usersListArray.users;
    } else {
      var error = json['error'];
      return error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context),
      // body: Container(child: _buildFuture()),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          getDataFromAPI();
        }, child: _buildFuture(),),
    );
  }

  FutureBuilder<dynamic> _buildFuture() {
    return FutureBuilder<dynamic>(
      future: getDataFromAPI(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List<NotificationList>?) {
            List<NotificationList>? usersArray = snapshot.data;
            if (usersArray!.length > 0) {
              return _buildGridView(context, usersArray);
            } else {
              return _showErrorMessage('No Offers Available');
            }
          } else {
            return _showErrorMessage(snapshot.data.toString());
          }
        } else if (snapshot.hasError) {
          return _showErrorMessage(snapshot.error.toString());
        } else {
          return _buildLoader();
        }
      },
    );
  }

  ListView _buildGridView(BuildContext context, List<NotificationList> users) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _buildNotificationCell(context, users[index]);
      },
    );
  }

  Widget _buildNotificationCell(BuildContext context, NotificationList promotionObj) {
    return InkWell(
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => OfferDetails(
      //         obj: promotionObj,
      //       // ),
      //     ),
      //   );
      // },
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promotionObj.message ?? "",
                        style: TextStyle(
                            overflow: TextOverflow.clip,
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 15, 5, 0),
              height: 5,
              padding: EdgeInsets.symmetric(horizontal: 100),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/line.png'), fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noContentText(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Container(
          child: Center(
            child: Text(
              'No Notifications Available',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
          )),
    );
  }

  Center _showErrorMessage(String errorMessage) {
    return Center(
      child: Text(errorMessage),
    );
  }

  Center _buildLoader() {
    return Center(
      child: SpinKitCircle(
        color: Colors.red,
        size: 50.0,
      ),
    );
  }
}