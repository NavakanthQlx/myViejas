import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:viejas/model/home.dart';
import 'package:viejas/screens/CommonDetail.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:viejas/screens/EventScreen.dart';
import 'package:viejas/screens/Promotions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CasinoList? casinoListObj;

  Future<dynamic> getDataFromAPI() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('connected');
    } else if (connectivityResult == ConnectivityResult.none) {
      Utils.showToast('Please check your Internet Connection');
      return [];
    }
    String url = Constants.loadCasino + "category_id=1&casino_id=30";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    print('json -> $json');
    if (response.statusCode == 200) {
      var usersListArray = Casino.fromJson(json.first);
      // setState(() {
      casinoListObj = usersListArray.data.first;
      // });
      return usersListArray.data;
    } else {
      var error = json['error'];
      return error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            // _buildHeaderImage(),
            Expanded(child: _buildFuture()),
          ],
        ),
      ),
    );
  }

  FutureBuilder<dynamic> _buildFuture() {
    return FutureBuilder<dynamic>(
      future: getDataFromAPI(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List<CasinoList>?) {
            List<CasinoList>? usersArray = snapshot.data;
            if (usersArray!.length > 0) {
              return Column(
                children: [
                  _buildHeaderImage(),
                  Expanded(
                      child:
                          _buildGridView(context, usersArray.first.services)),
                ],
              );
            } else {
              return _showErrorMessage('Empty users');
            }
          } else {
            print(snapshot.data);
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

  GridView _buildGridView(BuildContext context, List<Service> users) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 3 / 3.7,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2),
      itemCount: users.length,
      itemBuilder: (BuildContext ctx, index) {
        return GestureDetector(
          onTap: () {
            Service obj = users[index];
            String title = users[index].serviceName;
            switch (title) {
              case "Dining":
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommonDetailScreen(
                            bannerImageUrl: obj.serviceIcon,
                          )),
                );
                break;
              case "Hotel":
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventScreen(
                            bannerImageUrl: obj.serviceIcon,
                          )),
                );
                break;
              case "Promotions":
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Promotions(
                            bannerImageUrl: obj.serviceIcon,
                            showAppBar: true,
                          )),
                );
                break;
              default:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommonDetailScreen(
                            bannerImageUrl: obj.serviceIcon,
                          )),
                );
                break;
            }
          },
          child: Container(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: double.infinity,
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Center(
                      child: Stack(alignment: Alignment.center, children: [
                        Container(
                          height: double.infinity,
                          child: Image(
                              fit: BoxFit.fill,
                              image:
                                  AssetImage('images/placeholderimage.jpeg')),
                        ),
                        Container(
                            height: 20,
                            width: 20,
                            child: const CircularProgressIndicator()),
                      ]),
                    ),
                    imageUrl: users[index].serviceIcon,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black54,
                  child: Text(
                    users[index].serviceName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  Widget _buildHeaderImage() {
    return Stack(alignment: Alignment.bottomCenter, children: [
      Container(
        alignment: Alignment.center,
        height: 230.0,
        width: double.infinity,
        child: CachedNetworkImage(
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
          placeholder: (context, url) => Center(
            child: Stack(alignment: Alignment.center, children: [
              Container(
                height: double.infinity,
                width: double.infinity,
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
          imageUrl: casinoListObj?.logo ?? '',
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

  // ignore: unused_element
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
}
