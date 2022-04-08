import 'package:daedalus/data/facility_data.dart';
import 'package:flutter/material.dart';
import 'package:daedalus/pages/map_page.dart';
import 'package:daedalus/pages/about_page.dart';
import 'package:daedalus/pages/search_page.dart';
import 'package:daedalus/utils/location_utils.dart';
import 'package:daedalus/models/facility_model.dart';
import 'package:daedalus/utils/view_utils.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    List<dynamic> results = await getClosestFacility();
    if (results.isNotEmpty) {
      var distance = results[0];
      var facility = results[1];
      if (distance < 100) {
        print("distance:");
        print(distance);
      }
      else {
        print('ho');
      }
    }
    return Future.value(true);
  });
}


void setupNotifications() {
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );

  Workmanager().registerOneOffTask(
      "13",
      "simpTask",
      //frequency: Duration(minutes: 15),
      initialDelay: Duration(seconds: 15),
      existingWorkPolicy: ExistingWorkPolicy.replace,
  );
}

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: MainApp()));//
  Workmanager().cancelAll();
  setupNotifications();
}

class MainApp extends StatefulWidget {

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<Facility> facilities = [];

  @override
  void initState() {
    super.initState();

    getLocationPermissions(context).then((permissionGranted) {
      sortFacilities(permissionGranted).then((sorted) {
        setState(() {
          facilities = sorted;
        });
      });
    });
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
            height: 50,
            child: AppBar(
              backgroundColor: HexColor("#676d42"),
              bottom: TabBar(
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