import 'package:daedalus/data/facility_data.dart';
import 'package:flutter/material.dart';
import 'package:daedalus/pages/map_page.dart';
import 'package:daedalus/pages/about_page.dart';
import 'package:daedalus/pages/search_page.dart';
import 'package:daedalus/utils/location_utils.dart';
import 'package:daedalus/models/facility_model.dart';
import 'package:daedalus/utils/view_utils.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_geofence/geofence.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    List<dynamic> results = await getClosestFacility();
    if (results.isNotEmpty) {
      var distance = results[0];
      var facility = results[1];
      if (distance < 2000) {
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


void setupGeolocationAlertsForAndroid() {
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  Workmanager().registerOneOffTask(
    "29",
    "simpleTask",
    // frequency: Duration(minutes: 15),
    initialDelay: Duration(seconds: 1),
    existingWorkPolicy: ExistingWorkPolicy.replace,
  );
}

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: MainApp()));//
  if (Platform.isAndroid) {
    setupGeolocationAlertsForAndroid();
  }
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

    permissionHandler().then((permissionStatus) {
      // if (permissionStatus < 1) { showLocationSettings(context); }
      sortFacilities(permissionStatus).then((sorted) {
        setState(() {
          facilities = sorted;
        });
        print(facilities[0].facid);
        if (permissionStatus > 1 && Platform.isIOS) {
          print('running alerts for ios');
          setupGeolocationAlertsForIOS();
        }
      });
    });

    /*
    getLocationPermissions(context).then((permissionGranted) {
      sortFacilities(permissionGranted).then((sorted) {
        setState(() {
          facilities = sorted;
        });
        print(facilities[0].facid);
        if (permissionGranted && Platform.isIOS) {
          print('running alerts for ios');
          setupGeolocationAlertsForIOS();
        }
      });
    });
     */
  }

  void setupGeolocationAlertsForIOS() {
    permissionHandler().then((permissionStatus) {
      if (permissionStatus > 1) { addGeofences(); }
    });
  }

  void addGeofences() {
    Geofence.initialize();
    // Geofence.getCurrentLocation().then((value) => print(value)).onError((error, stackTrace) => print(error));
    Geofence.getCurrentLocation().then((coordinate) {
      print("Your latitude is ${coordinate?.latitude} and longitude ${coordinate?.longitude}");
    });

    for (var facility in facilities.take(10)) {
      Geofence.addGeolocation(Geolocation(
          latitude: facility.lat,
          longitude: facility.long,
          radius: 100,
          id: facility.facid), GeolocationEvent.entry).then((value) => print("added"));
    }

    Geofence.startListening(GeolocationEvent.entry, (entry) {
      print("Entry of a georegion Welcome to: ${entry.id}");
    });
  }

  Future<int> permissionHandler() async {
    if (await Permission.locationAlways.isGranted) {
      return 2;
    }
    else if (!await Permission.locationWhenInUse.isGranted) {
      await Permission.locationWhenInUse.request();
      if (await Permission.locationWhenInUse.isGranted) {
        Platform.isAndroid ? showLocationSettings(context, requestAlways :Permission.locationAlways.request) : await Permission.locationAlways.request();
      }
    }
    else {
      Platform.isAndroid ? showLocationSettings(context, requestAlways : Permission.locationAlways.request) : await Permission.locationAlways.request();
    }

    if (await Permission.locationAlways.isGranted) {
      return 2;
    }
    else if (await Permission.locationWhenInUse.isGranted) {
      return 1;
    }
    else {
      showLocationSettings(context);
      return 0;
    }
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