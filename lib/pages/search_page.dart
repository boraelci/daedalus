import 'package:flutter/material.dart';
import 'package:daedalus/data/facility_data.dart';
import 'package:daedalus/pages/facility_page.dart';
import 'package:daedalus/widgets/search_widget.dart';
import 'package:daedalus/models/facility_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class SearchPage extends StatefulWidget {

  SearchPage({
    Key? key,
  }) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {

  List<Facility> facilities = [];
  String query = '';

  LatLng defaultLoc = LatLng(40.7128, 74.0060);
  LatLng? userLocation;

  late List<String> facilityTexts;
  late List<Color> facilityColors;

  String safeText = "Lead presence is below the 2020 EPA limit for housing and child occupied facilities.\n\nVery low risk of transferring lead contamination away from the workplace.";
  String lowText = "Lead presence is below the 2001 EPA limit for housing and child occupied facilities.\n\nWash hands and follow good personal hygiene habits following onsite activities. Low risk of transferring lead contamination away from the workplace.";
  String mediumText = "Lead presence is below the OSHA limit for contaminated workplaces.\n\nWash hands and follow good personal hygiene habits following onsite activities. Follow all required housekeeping procedures and ensure break areas are clean and sanitary. Medium risk of transferring lead contamination away from the workplace.";
  String highText = "Lead presence is above OSHA limit for maintaining a clean and sanitary break areas away from ongoing onsite activities.\n\nInquire with facility coordinator on measures to lower the risk of lead contamination. Follow all required housekeeping procedures. High risk of transferring lead contamination away from the workplace.";

  @override
  void initState() {
    super.initState();
    facilityTexts = [safeText, lowText, mediumText, highText];
    facilityColors = [Colors.green, Colors.green, Colors.green, Colors.orange];
    _getReady();
  }

  void _getReady() async {
    facilities = [...allFacilities];
    try {
      await _determinePosition().then((pos) =>
      {
        facilities.sort((a, b) {
          double distanceForA = Geolocator.distanceBetween(
              pos.latitude, pos.longitude, a.lat, a.long);
          double distanceForB = Geolocator.distanceBetween(
              pos.latitude, pos.longitude, b.lat, b.long);
          return distanceForA.compareTo(distanceForB);
        })
      });
    }
    catch (e) {
      print("Location permissions not properly configured!");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var pos = await Geolocator.getCurrentPosition();
    setState(() {
      userLocation = LatLng(pos.latitude, pos.longitude);
    });
    return pos;
  }

  void _showGuidelines(index) {
    Facility facility = facilities[index];
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text.rich(TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: facility.leadSeverity < 3 ? "Within" : "Above",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: facilityColors[facility.leadSeverity]
                ),
              ),
              const TextSpan(
                text: " permissible limits",
                // style: TextStyle(fontSize: 14.0),
              ),
            ],
          )),
          content: Text(facilityTexts[facility.leadSeverity]),
          actions: <Widget>[
            /*
            TextButton(
              onPressed: () => Navigator.pop(context, 'Learn more'),
              child: const Text('Learn more'),
            ),*/
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(children: <Widget>[
            buildSearch(),
            Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(
                        indent: 20,
                        endIndent: 20,
                        thickness: 1,
                      );
                    },
                    itemCount: facilities.length,
                    itemBuilder: (context, index) {
                      final facility = facilities[index];
                      return buildFacility(facility, index);
                    }))
          ]),
        ));
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Search for a facility',
    onChanged: searchFacility,
  );

  final itemSize = 75.0;
  int _selectedIndex = 0;

  Widget buildFacility(Facility facility, int index) => SizedBox(
    height: itemSize,
    child: ListTile(
        selected: index == _selectedIndex,
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        // selectedTileColor: Colors.blueGrey.shade100.withOpacity(0.25),
        selectedColor: Colors.black,
        horizontalTitleGap: 12,
        leading: IconButton(
          iconSize: 45,
          icon: facility.leadSeverity < 3
              ? const FaIcon(FontAwesomeIcons.circleCheck,
              color: Colors.green)
              : const FaIcon(FontAwesomeIcons.circleExclamation,
              color: Colors.amber),
          onPressed: () => _showGuidelines(index),
        ),
        title: Text(facility.siteName,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            )),
        subtitle: Text(
          '${facility.city}, ${facility.state}',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
        ),
        trailing: IconButton(
            iconSize: 20,
            icon: const FaIcon(FontAwesomeIcons.fileLines,
                color: Colors.grey),
            onPressed: () {
              /*
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FacilityPage(facility: facility)),
              );*/
              _showGuidelines(index);
            })),
  );

  void searchFacility(String query) {
    final facilities = allFacilities.where((facility) {
      final searchLower = query.toLowerCase();

      final siteNameLower = facility.siteName.toLowerCase();
      final cityLower = facility.city.toLowerCase();

      return siteNameLower.contains(searchLower) ||
          cityLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.facilities = facilities;
    });
  }

  void searchFacilityById(String facilityId) {
    final facilities = allFacilities.where((facility) {
      return facility.facid.contains(facilityId);
    }).toList();

    setState(() {
      this.facilities = facilities;
    });
  }
}
