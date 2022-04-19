import 'package:flutter/material.dart';
import 'package:daedalus/pages/map_page.dart';
import 'package:daedalus/pages/about_page.dart';
import 'package:daedalus/pages/search_page.dart';
import 'package:daedalus/utils/location_utils.dart';
import 'package:daedalus/models/facility_model.dart';
import 'package:daedalus/utils/view_utils.dart';

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
  List<Facility> facilities = [];

  @override
  void initState() {
    super.initState();

    getLocationPermissions(context).then((permissionStatus) {
      sortFacilities(permissionStatus).then((sorted) {
        if (permissionStatus > 1) { // meaning locationAlways enabled
          // setupGeolocationAlerts(sorted, radius: 100.0); COMMENTED FOR DEBUGGING
        }
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