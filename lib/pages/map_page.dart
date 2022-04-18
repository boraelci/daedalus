import 'package:daedalus/data/facility_data.dart';
import "package:flutter/material.dart";
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:daedalus/models/facility_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daedalus/utils/location_utils.dart';
import 'package:flutter_placeholder_textlines/placeholder_lines.dart';
import 'package:daedalus/utils/view_utils.dart';
import 'package:daedalus/pages/facility_page.dart';

class MapPage extends StatefulWidget {
  final List<Facility> facilities;

  const MapPage({Key? key, required this.facilities}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  double defaultZoom = 13.0;
  LatLng? userLocation;

  int _selectedIndex = 0; // for list tiles

  List<Marker> markers = [];
  final itemSize = 75.0;

  late ScrollController _scrollController;
  late MapController _mapController;

  List<Facility> facilities = [];

  final leadSeverityThreshold = 3;
  final numFacilitiesToDisplay = 10;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
/*
    Timer.periodic(Duration(seconds: 5), (timer) {
      _updateUserLocation();
    });
 */

  }

  void _updateUserLocation() async {
    try {
      await getUserLocation().then((loc) {
        // do not wrap in setState
        userLocation = LatLng(loc.latitude, loc.longitude);
        print(userLocation);
      });
    }
    catch(e) {
    }
  }

  void _onMarkerTapped(int index) {
    _zoomCamera(index, 15.0);
    _scrollToItem(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  /*
  void fixLocation() {
    List<Location> locations = await locationFromAddress(
        facility.address);
    point = LatLng(locations[0].latitude, locations[0].longitude);
  }*/

  void _addMarkers(facilities) async {
    List<Marker> _markers = [];
    var counter = 0;
    for (var facility in facilities.take(numFacilitiesToDisplay)) {
      final index = counter;
      try {
        var point = LatLng(facility.lat, facility.long);
        try {

        } catch (e){
          print(facility.address);
          print("Coordinates from address could not be found");
        }
        final Marker marker = Marker(
          width: 80.0,
          height: 80.0,
          point: point,
          builder: (ctx) => GestureDetector(
            onTap: () {
          _onMarkerTapped(index);
            },
            child: Container(
          alignment: Alignment.center, // use alignment
          child: Image.asset(
              facility.leadSeverity < leadSeverityThreshold
                  ? 'assets/images/greenCircle256px_30br.png'
                  : 'assets/images/orangeCircle256px_30br.png',
              height: 30,
              width: 30,
              fit: BoxFit.cover),
            ),
          ),
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

  void _scrollToItem(int index) {
    double oneScroll = itemSize;
    _scrollController.jumpTo(oneScroll * index);
  }

  void _zoomCamera(int index, double zoom) {
    _mapController.move(
        LatLng(facilities[index].lat, facilities[index].long), zoom);
  }

  void _showGuidelines(index) {
    Facility facility = facilities[index];
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text.rich(TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: facility.leadSeverity < leadSeverityThreshold ? "Within" : "Above",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: facilityColors[facility.leadSeverity]),
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
    facilities = widget.facilities;
    if (markers.isEmpty && facilities.isNotEmpty) {
      _addMarkers(facilities);
    }
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: HexColor("#676d42"),
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: facilities.isEmpty ? const Center(child: CircularProgressIndicator()) : FlutterMap(
                options: MapOptions(
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  center: LatLng(facilities[0].lat, facilities[0].long),
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
            const Divider(thickness: 1, height: 1),
            Expanded(
              flex: 1,
              child: facilities.isEmpty ? _buildPlaceholderList() : _buildList())
          ]
        ));
  }

  Widget _buildTile(Facility facility, int index) => SizedBox(
    height: itemSize,
    child: ListTile(
        selected: index == _selectedIndex,
        onTap: () {
          setState(() {
            _zoomCamera(index, 15.0);
            _selectedIndex = index;
          });
        },
        selectedTileColor: Colors.blueGrey.shade100.withOpacity(0.25),
        selectedColor: Colors.black,
        horizontalTitleGap: 12,
        leading: IconButton(
          iconSize: 45,
          icon: facility.leadSeverity < leadSeverityThreshold
              ? const FaIcon(FontAwesomeIcons.circleCheck,
              color: Colors.green)
              : const FaIcon(FontAwesomeIcons.circleExclamation,
              color: Colors.amber),
          onPressed: () {
            setState(() {
              _zoomCamera(index, 15.0);
              _selectedIndex = index;
            });
            _showGuidelines(index);
          }
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
            icon: const FaIcon(FontAwesomeIcons.chevronRight,
                color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FacilityPage(facility: facilities[index])),
              );
              // setState(() {
              //   _zoomCamera(index, 15.0);
              //   _selectedIndex = index;
              // });
              // _showGuidelines(index);
            })),
  );

  Widget _buildList() {
    return ListView.builder(
        controller: _scrollController,
        itemCount: facilities.length,
        itemBuilder: (context, index) {
          final facility = facilities[index];
          return _buildTile(facility, index);
        });
  }

  Widget _buildPlaceholderTile() => SizedBox(
      height: itemSize,
      child: const ListTile(
          selectedColor: Colors.black,
          horizontalTitleGap: 12,
          contentPadding: EdgeInsets.symmetric(horizontal: 25),
          leading: Icon(Icons.photo_rounded, size: 50),
          title: PlaceholderLines(count: 1, animate: true),
          subtitle: PlaceholderLines(count: 1, animate: true),
          trailing: FaIcon(FontAwesomeIcons.chevronRight, color: Colors.grey, size: 20)));

  Widget _buildPlaceholderList() {
    return ListView.builder(
        controller: _scrollController,
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildPlaceholderTile();
        });
  }
}
