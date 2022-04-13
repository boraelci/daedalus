import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:daedalus/data/facility_data.dart';
import 'package:daedalus/location/location_callback.dart';
import 'package:daedalus/notification/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:daedalus/pages/map_page.dart';
import 'package:daedalus/pages/about_page.dart';
import 'package:daedalus/pages/search_page.dart';
import 'package:daedalus/utils/location_utils.dart';
import 'package:daedalus/models/facility_model.dart';
import 'package:daedalus/utils/view_utils.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  runApp(MaterialApp(home: MainApp()));
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
    initPlatformState();
    getLocationPermissions(context).then((permissionGranted) {
      sortFacilities(permissionGranted).then((sorted) {
        setState(() {
          facilities = sorted;
        });
      });
    });
  }

  Future<void> initPlatformState() async {
    final locationWhenInUseStatus = await Permission.locationWhenInUse.request();
    print("Location when in use status: $locationWhenInUseStatus");
    if (locationWhenInUseStatus.isGranted) {
      print("Location when in use is granted");
      var locationAlwaysStatus = await Permission.locationAlways.request();
      print("After requesting location always");

      if (!locationAlwaysStatus.isGranted) {
        print("Location always is denied");
        bool res = await openAppSettings();
      }

    }
    if (!locationWhenInUseStatus.isGranted) {
      print("Location when in use is not granted");
    }
    await BackgroundLocator.initialize();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    print('Running ${_isRunning.toString()}');
    _startLocator();

  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 2,
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
void _startLocator() async{
  Map<String, dynamic> data = {'countInit': 1};
  BackgroundLocator.registerLocationUpdate(LocationCallbackHandler.callback,
      initCallback: LocationCallbackHandler.initCallback,
      initDataCallback: data,
      disposeCallback: LocationCallbackHandler.disposeCallback,
      iosSettings: const IOSSettings(
          accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 250),
      autoStop: false,
      androidSettings: const AndroidSettings(
          accuracy: LocationAccuracy.NAVIGATION,
          interval: 5,
          distanceFilter: 250,
          client: LocationClient.google,
          androidNotificationSettings: AndroidNotificationSettings(
              notificationChannelName: 'Location tracking',
              notificationTitle: 'Start Location Tracking',
              notificationMsg: 'Track location in background',
              notificationBigMsg:
              'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
              notificationIcon: '',
              notificationIconColor: Colors.grey,
              notificationTapCallback:
              LocationCallbackHandler.notificationCallback)));
}
