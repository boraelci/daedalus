import 'dart:async';

import 'package:flutter/material.dart';
import 'package:daedalus/data/facility_data.dart';
import 'package:daedalus/pages/facility_page.dart';
import 'package:daedalus/widgets/search_widget.dart';
import 'package:daedalus/models/facility_model.dart';
import 'package:flutter_placeholder_textlines/placeholder_lines.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:daedalus/utils/location_utils.dart';
import 'package:daedalus/utils/view_utils.dart';

class SearchPage extends StatefulWidget {
  final List<Facility> facilities;

  SearchPage({Key? key, required this.facilities}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  String query = '';
  LatLng? userLocation;

  bool firstTime = true;

  final itemSize = 75.0;
  int _selectedIndex = 0;

  List<Facility> facilities = [];

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 7), (timer) {
      _updateUserLocation();
    });
  }

  void _updateUserLocation() async {
    try {
      await getUserLocation().then((loc) {
        // do not wrap in setstate
        userLocation = LatLng(loc.latitude, loc.longitude);
        print(userLocation);
      });
    }
    catch(e) {
    }
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
    if (firstTime == true &&
        facilities.isEmpty &&
        widget.facilities.isNotEmpty) {
      firstTime = false;
      setState(() {
        facilities = widget.facilities;
      });
    }
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: HexColor("#676d42"),
          elevation: 0.0,
        ),
        body: SafeArea(
      child: Column(children: <Widget>[
        widget.facilities.isEmpty ? _buildSearch(false) : _buildSearch(true),
        Expanded(
            child: widget.facilities.isEmpty
                ? _buildPlaceholderList()
                : _buildList())
      ]),
    ));
  }

  Widget _buildTile(Facility facility, int index) => SizedBox(
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
          onPressed: () {
            setState(() {
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
              //   _selectedIndex = index;
              // });
              // _showGuidelines(index);
            })),
  );

  Widget _buildList() {
    return ListView.separated(
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
          return _buildTile(facility, index);
        });
  }

  void _searchFacility(String query) {
    final facilities = widget.facilities.where((facility) {
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

  Widget _buildSearch(en) => SearchWidget(
        text: query,
        hintText: 'Search by facility name or city',
        onChanged: _searchFacility,
        enabled: en,
      );

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
    return ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider(
            indent: 20,
            endIndent: 20,
            thickness: 1,
          );
        },
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildPlaceholderTile();
        });
  }
}
