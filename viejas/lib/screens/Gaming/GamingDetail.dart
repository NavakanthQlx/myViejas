import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:viejas/model/gamingdetail.dart';
import 'package:viejas/screens/WebViewScreen.dart';

class GamingDetail extends StatefulWidget {
  final String gamingId;
  const GamingDetail({Key? key, required this.gamingId}) : super(key: key);

  @override
  _GamingDetailState createState() => _GamingDetailState();
}

class _GamingDetailState extends State<GamingDetail> {
  String bannerImageUrl = "";

  Future<dynamic> getDataFromAPI() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('connected');
    } else if (connectivityResult == ConnectivityResult.none) {
      Utils.showToast('Please check your Internet Connection');
      return [];
    }
    String urlStr = Constants.getGamingDetailUrl;
    String casinoId = await UserManager.getCasinoId();
    var params = {"casino_id": casinoId, "id": widget.gamingId};
    var url = Uri.parse(urlStr);
    var response = await http.post(
      url,
      body: convert.jsonEncode(params),
    );
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      var usersListArray = gamingDetailRootFromJson(response.body);
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
          if (snapshot.data is List<GamingDetailRoot>?) {
            List<GamingDetailRoot>? usersArray = snapshot.data;
            if (usersArray!.length > 0) {
              bannerImageUrl = usersArray.first.bannerImage;
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

  ListView _buildListView(BuildContext context, List<GamingDetailRoot> users) {
    return ListView.builder(
      itemCount: users.first.datavalues.length + 3,
      shrinkWrap: true,
      itemBuilder: (contex, index) {
        if (index == 0) {
          return _buildHeaderImage();
        } else if (index == 1) {
          return _buildNewSlots(users.first);
        } else if (index == 2) {
          return _buildNowFeaturing(users.first);
        } else {
          return _buildDiningCell(context, users.first.datavalues[index - 3]);
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
        fit: BoxFit.fill,
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

  Widget _buildDiningCell(BuildContext context, GamingDetailDatavalue obj) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WebViewScreen()),
        );
      },
      child: _buildBottomCell(obj),
    );
  }

  Container _buildNewSlots(GamingDetailRoot obj) {
    return Container(
      margin: EdgeInsets.fromLTRB(25, 15, 15, 15),
      child: Column(
        children: [
          Text(
            obj.headerTitle,
            style: TextStyle(
                overflow: TextOverflow.visible,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(
            height: 8,
          ),
          Container(height: 3, width: 150, color: Colors.red),
          SizedBox(
            height: 15,
          ),
          Text(
            obj.description,
            style: TextStyle(
                overflow: TextOverflow.visible,
                fontSize: 15,
                color: Colors.white),
          ),
        ],
      ),
    );
  }

  Container _buildNowFeaturing(GamingDetailRoot obj) {
    return Container(
      margin: EdgeInsets.fromLTRB(25, 15, 15, obj.features == "" ? 0 : 15),
      child: Column(
        children: [
          Text(
            obj.features == "" ? "Now Featuring" : "Features Include:",
            style: TextStyle(
                overflow: TextOverflow.visible,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(
            height: 8,
          ),
          Container(height: 3, width: 150, color: Colors.red),
          SizedBox(
            height: obj.features == "" ? 0 : 15,
          ),
          Text(
            obj.features,
            style: TextStyle(
                overflow: TextOverflow.visible,
                fontSize: 15,
                color: Colors.white),
          ),
        ],
      ),
    );
  }

  Container _buildBottomCell(GamingDetailDatavalue obj) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      // height: 600,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      alignment: Alignment.center,
      child: Column(
        children: [
          Visibility(
            visible: (obj.imageUrl != "" && obj.imageUrl.contains('.jpg')),
            child: Container(
              width: double.infinity,
              height: obj.imageUrl != "" ? 300.0 : 0,
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                placeholder: (context, url) => Center(
                  child: Stack(alignment: Alignment.center, children: [
                    Container(
                      height: 300,
                      child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage('images/placeholderimage.jpeg')),
                    ),
                    Container(
                        height: 20,
                        width: 20,
                        child: const CircularProgressIndicator()),
                  ]),
                ),
                imageUrl: obj.imageUrl,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  obj.title,
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
                  obj.description,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      overflow: TextOverflow.visible,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
