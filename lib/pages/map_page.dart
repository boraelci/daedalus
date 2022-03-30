import "package:flutter/material.dart";
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:daedalus/data/facility_data.dart';
import 'package:daedalus/models/facility_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daedalus/pages/facility_page.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

final PopupController _popupLayerController = PopupController();

class _MapPageState extends State<MapPage> {
  LatLng defaultLoc = LatLng(40.7128, -74.0060);
  double defaultZoom = 13.0;
  LatLng? userLocation;

  int _selectedIndex = 0; // for list tiles

  List<Marker> markers = [];
  List<Facility> facilities = [];
  final itemSize = 75.0;

  late ScrollController _scrollController;
  late MapController _mapController;

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
    _scrollController = ScrollController();
    _getMarkersReady();
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

  void _getMarkersReady() async {
    facilities = [...allFacilities];
    try {
      await _determinePosition().then((pos) {
        facilities.sort((a, b) {
          double distanceForA = Geolocator.distanceBetween(
              pos.latitude, pos.longitude, a.lat, a.long);
          double distanceForB = Geolocator.distanceBetween(
              pos.latitude, pos.longitude, b.lat, b.long);
          return distanceForA.compareTo(distanceForB);
        });
        zoomCamera(0, defaultZoom);
      });
    }
    catch (e) {
      print("Location permissions not properly configured!");
    }
    _addMarkers();
  }

  void _onMarkerTapped(int index) {
    zoomCamera(index, 15.0);
    scrollToItem(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addMarkers() {
    List<Marker> _markers = [];
    var counter = 0;
    for (var facility in facilities) {
      final index = counter;
      try {
        final Marker marker = Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(facility.lat, facility.long),
          builder: (ctx) => Container(
              child: GestureDetector(
            onTap: () {
              _onMarkerTapped(index);
            },
            child: Container(
              alignment: Alignment.center, // use aligment
              child: Image.asset(
                  facility.leadSeverity < 3
                      ? 'assets/images/greenCircle256px_30br.png'
                      : 'assets/images/orangeCircle256px_30br.png',
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover),
            ),
          )),
        );
        _markers.add(marker);
        counter += 1;
      } catch (e) {
        print("Facilities and markers out of sync!");
        continue;
      }
    }
    setState(() {
      markers = _markers;
    });
  }

  void scrollToItem(int index) {
    double oneScroll = itemSize;
    _scrollController.jumpTo(oneScroll * index);
  }

  void zoomCamera(int index, double zoom) {
    _mapController.move(
        LatLng(facilities[index].lat, facilities[index].long), zoom);
  }

  Widget buildFacility(Facility facility, int index) => SizedBox(
        height: itemSize,
        child: ListTile(
            selected: index == _selectedIndex,
            onTap: () {
              setState(() {
                zoomCamera(index, 15.0);
                _selectedIndex = index;
              });
            },
            selectedTileColor: Colors.blueGrey.shade100.withOpacity(0.25),
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
                  color:
                  facilityColors[facility.leadSeverity]
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

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          title: const Text("Select a facility",
              style: TextStyle(color: Colors.black54, fontSize: 16.0)),
          /* leading: IconButton(
      iconSize: 24.0,
      icon: const Icon(Icons.search, color: Colors.black54),
      onPressed: () => {
      // TODO: What to do when Search button is pressed?
      },
    ), */
          backgroundColor: Colors.white,
          elevation: 5.0,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: FlutterMap(
                options: MapOptions(
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  center: userLocation != null ? userLocation : defaultLoc,
                  zoom: defaultZoom,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(markers: markers)
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  width: width,
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: facilities.length,
                      itemBuilder: (context, index) {
                        final facility = facilities[index];
                        return buildFacility(facility, index);
                      })),
            ),
          ],
        ));
  }
}
