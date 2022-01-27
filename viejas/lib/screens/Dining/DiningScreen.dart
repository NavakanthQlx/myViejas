import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:viejas/model/diningModel.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:viejas/screens/Dining/DiningDetail.dart';

class DiningScreen extends StatefulWidget {
  final String bannerImageUrl;

  const DiningScreen({Key? key, required this.bannerImageUrl})
      : super(key: key);

  @override
  _DiningScreenState createState() => _DiningScreenState();
}

class _DiningScreenState extends State<DiningScreen> {
  String? bannerImageUrl;
  String? headerTitle;

  Future<dynamic> getDataFromAPI() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('connected');
    } else if (connectivityResult == ConnectivityResult.none) {
      Utils.showToast('Please check your Internet Connection');
      return [];
    }
    String urlStr = Constants.getDiningUrl;
    String casinoId = await UserManager.getCasinoId();
    var params = {'casino_id': casinoId};
    var url = Uri.parse(urlStr);
    var response = await http.post(
      url,
      body: convert.jsonEncode(params),
    );
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      var usersListArray = diningObjectFromJson(response.body);
      bannerImageUrl = usersListArray.first.bannerImage;
      headerTitle = usersListArray.first.mainHeader;
      return usersListArray.first.venueData;
    } else {
      var error = json['error'];
      return error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 30), child: _buildFuture()),
    );
  }

  FutureBuilder<dynamic> _buildFuture() {
    return FutureBuilder<dynamic>(
      future: getDataFromAPI(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List<VenueDatum>?) {
            List<VenueDatum>? usersArray = snapshot.data;
            if (usersArray!.length > 0) {
              return _buildListView(context, usersArray);
            } else {
              return _showErrorMessage('Something went wrong');
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

  ListView _buildListView(BuildContext context, List<VenueDatum> users) {
    return ListView.builder(
      itemCount: users.length + 2,
      itemBuilder: (contex, index) {
        if (index == 0) {
          return _buildHeaderImage();
        } else if (index == 1) {
          return _buildSectionHeaderText();
        } else {
          return _buildDiningCell(context, users[index - 2]);
        }
      },
    );
  }

  Container _buildHeaderImage() {
    if (bannerImageUrl != null) {
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
        imageUrl: bannerImageUrl ?? "",
      ),
    );
  }

  Padding _buildSectionHeaderText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          headerTitle ?? "",
          style: TextStyle(
              overflow: TextOverflow.clip,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
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

  Widget _buildDiningCell(BuildContext context, VenueDatum obj) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiningDetail(
              venueId: obj.venueId,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70.0,
                  height: 70.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: Stack(alignment: Alignment.center, children: [
                          Container(
                            height: double.infinity,
                            child: Image(
                                fit: BoxFit.cover,
                                image:
                                    AssetImage('images/placeholderimage.jpeg')),
                          ),
                          Container(
                              height: 20,
                              width: 20,
                              child: const CircularProgressIndicator()),
                        ]),
                      ),
                      imageUrl: obj.venueImage,
                    ),
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
                        obj.venueTitle,
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        obj.venueShortDescription,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            overflow: TextOverflow.visible,
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: Colors.white70),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
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
}
