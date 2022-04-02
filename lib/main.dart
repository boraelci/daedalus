import 'package:daedalus/data/facility_data.dart';
import 'package:flutter/material.dart';
import 'package:daedalus/pages/map_page.dart';
import 'package:daedalus/pages/settings_page.dart';
import 'package:daedalus/pages/search_page.dart';
import 'package:daedalus/utils/location_utils.dart';
import 'package:daedalus/models/facility_model.dart';
import 'package:daedalus/utils/view_utils.dart';

void main() {
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
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          body: TabBarView(
            children: [
              //SearchPage(facilities: facilities),
              SearchPage(facilities: facilities),
              MapPage(facilities: facilities),
              const SettingsPage(),
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