import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:viejas/model/diningdetail.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:viejas/screens/WebViewScreen.dart';

class DiningDetail extends StatefulWidget {
  final String venueId;
  const DiningDetail({Key? key, required this.venueId}) : super(key: key);

  @override
  _DiningDetailState createState() => _DiningDetailState();
}

class _DiningDetailState extends State<DiningDetail> {
  String bannerImageUrl = "";
  List<String> timingsArray = [];

  Future<dynamic> getDataFromAPI() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('connected');
    } else if (connectivityResult == ConnectivityResult.none) {
      Utils.showToast('Please check your Internet Connection');
      return [];
    }
    String urlStr = Constants.getDiningDetailUrl;
    String casinoId = await UserManager.getCasinoId();
    var params = {"casino_id": casinoId, "venue_id": widget.venueId};
    var url = Uri.parse(urlStr);
    var response = await http.post(
      url,
      body: convert.jsonEncode(params),
    );
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      var usersListArray = diningDetailRootFromJson(response.body);
      return usersListArray;
    } else {
      var error = json['error'];
      return error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context),
      body: Container(child: _buildFuture()),
    );
  }

  FutureBuilder<dynamic> _buildFuture() {
    return FutureBuilder<dynamic>(
      future: getDataFromAPI(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List<DiningDetailRoot>?) {
            List<DiningDetailRoot>? usersArray = snapshot.data;
            if (usersArray!.length > 0) {
              bannerImageUrl = usersArray.first.bannerImage;
              timingsArray = usersArray.first.dinetime.split("\n");
              return _buildListView(context, usersArray);
            } else {
              return _showErrorMessage('Empty users');
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

  ListView _buildListView(BuildContext context, List<DiningDetailRoot> users) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (contex, index) {
        if (index == 0) {
          return _buildHeaderImage();
        } else if (index == 1) {
          return _buildViewMenu(users.first.menu);
        } else if (index == 2) {
          return Visibility(
              visible: timingsArray.length > 1,
              child: _buildTimingsCell(users.first.dinetime.split("\n")));
        } else {
          return _buildDiningCell(context, users.first);
        }
      },
    );
  }

  Container _buildHeaderImage() {
    if (bannerImageUrl.isNotEmpty) {
      return _buildHeaderImageFromNetwork();
    } else {
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
  }

  Container _buildHeaderImageFromNetwork() {
    return Container(
      height: 280.0,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: Stack(alignment: Alignment.center, children: [
            Container(
              height: double.infinity,
              child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage('images/placeholderimage.jpeg')),
            ),
            Container(
                height: 20,
                width: 20,
                child: const CircularProgressIndicator()),
          ]),
        ),
        imageUrl: bannerImageUrl,
      ),
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

  Widget _buildDiningCell(BuildContext context, DiningDetailRoot obj) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          _buildBottomCell(obj),
        ],
      ),
    );
  }

  List<Widget> createButton(List<DiningMenu> menu) {
    List<Widget> menuWidgets = [];
    for (var obj in menu) {
      menuWidgets.add(ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.redAccent),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewScreen(
                      urlString: obj.menuLink,
                    )),
          );
        },
        child: Text(obj.menuTitle),
      ));
    }
    return menuWidgets;
  }

  Container _buildViewMenu(List<DiningMenu> menu) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      padding: EdgeInsets.all(15),
      color: Colors.black,
      child: Column(
        children: createButton(menu),
      ),
    );
  }

  List<Widget> createText(List<String> timings) {
    List<Widget> menuWidgets = [];
    timings.asMap().forEach((index, value) => menuWidgets.add(
          Padding(
            padding: index.isOdd ? EdgeInsets.all(3) : EdgeInsets.all(7),
            child: Text(
              value,
              style: TextStyle(
                  overflow: TextOverflow.visible,
                  fontSize: index.isOdd ? 16 : 17,
                  fontWeight: FontWeight.bold,
                  color: index.isOdd ? Colors.white70 : Colors.white),
            ),
          ),
        ));
    return menuWidgets;
  }

  Container _buildTimingsCell(List<String> timings) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      padding: EdgeInsets.all(15),
      color: Colors.black,
      child: Column(
        children: [
          Text(
            'OUR HOURS',
            style: TextStyle(
                overflow: TextOverflow.visible,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(
            height: 8,
          ),
          Container(height: 3, width: 90, color: Colors.red),
          SizedBox(
            height: 20,
          ),
          Column(
            children: createText(timings),
          )
        ],
      ),
    );
  }

  Container _buildBottomCell(DiningDetailRoot obj) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            obj.mainHeader,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Container(height: 3, width: 150, color: Colors.red),
          SizedBox(
            height: 15,
          ),
          Text(
            timingsArray.length == 1
                ? (obj.longDescription +
                    "\n\n" +
                    obj.mainHeader +
                    " is " +
                    timingsArray.first)
                : obj.longDescription,
            textAlign: TextAlign.start,
            style: TextStyle(
                overflow: TextOverflow.visible,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white70),
          )
        ],
      ),
    );
  }
}
