import 'package:daedalus/data/facility_data.dart';
import 'package:daedalus/utils/notification_utils.dart';
import 'package:flutter/material.dart';

import 'package:daedalus/pages/map_page.dart';
import 'package:daedalus/pages/about_page.dart';
import 'package:daedalus/pages/search_page.dart';
import 'package:daedalus/utils/location_utils.dart';
import 'package:daedalus/models/facility_model.dart';
import 'package:daedalus/utils/view_utils.dart';
import 'dart:convert';
import 'package:http/http.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final String facilitiesURL =
      "https://daedalus-api-ziliqkhbea-uc.a.run.app/facilitymocks";

  final String safetyMessagesURL = "link";


  // (thresholdLevel), [(leve, message), (level, message)]

  List<Facility> facilities = [];

  NotificationService notificationService = NotificationService();

  late String thresholdLevel;
  late String safetyLevelAndMessages;

  @override
  void initState() {
    super.initState();

    getFacilities(facilitiesURL).then((unsorted) {
      // getSafetyMessages(safetyMessagesURL);
      getLocationPermissions(context).then((permissionStatus) {
        if (permissionStatus > 0) {
          sortFacilities(unsorted).then((sorted) {
            if (permissionStatus > 1) {
              notificationService.getNotificationPermissions().then((val) {
                setupGeolocationAlerts(sorted, notificationService.scheduleNotification, radius: 500.0);
              });
            }
            setFacilities(sorted);
          }).catchError((onError) {
            setFacilities(unsorted);
          });
        } else {
          setFacilities(unsorted);
        }
      }).catchError((onError) {
        setFacilities(unsorted);
      });
    });
  }

  void setFacilities(input) {
    setState(() {
      facilities = input;
    });
  }

  /*

  Future<void> getSafetyMessages(URL) async {

    Response res = await get(Uri.parse(URL));

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);

      thresholdLevel = body['thresholdLevel']; // threshold
      safetyLevelAndMessages = body['safetyLevelsAndMessages']; // {"1": "";}

      print(thresholdLevel);
      print(safetyLevelAndMessages);

    } else {
      print("Error connecting to server");
    }
  } */

  Future<List<Facility>> getFacilities(apiURL) async {

    Response res = await get(Uri.parse(apiURL));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Facility> facilities = List<Facility>.from(
          body.map((facility) => Facility.fromJson(facility)));
      return facilities;
    } else {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: const Text(
                    "Could not connect to the server. Ensure that you have an active internet connection and try restarting the app."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [
            //SearchPage(facilities: facilities),
            SearchPage(facilities: facilities),
            MapPage(facilities: facilities),
            AboutPage(),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 65,
          child: AppBar(
            backgroundColor: HexColor("#676d42"),
            bottom: TabBar(
              padding: const EdgeInsets.only(bottom: 15),
              indicatorColor: HexColor("#dfe0d6"),
              tabs: const [
                Tab(icon: Icon(Icons.search_rounded)),
                Tab(icon: Icon(Icons.map_rounded)),
                Tab(icon: Icon(Icons.info_rounded)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
