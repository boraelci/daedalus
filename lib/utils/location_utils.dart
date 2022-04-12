import 'package:daedalus/data/facility_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:daedalus/models/facility_model.dart';
import 'package:flutter/material.dart';

// This function is missing locationAlways permissions, so do not use
Future<bool> getLocationPermissions(context) async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.always) {
    return true;
  }

  else if (permission == LocationPermission.whileInUse) {
    permission = await Geolocator.requestPermission();
    showLocationSettings(context);
    return true;
  }

  permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    showLocationSettings(context);
    return false;
  }
  else if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
    return true;
  }
  else { return false; }
}

Future<Position> getUserLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission != LocationPermission.denied &&
      permission != LocationPermission.deniedForever) {
    var result;
    try {
      result = Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5));
    } catch (e) {
      try {
        result = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 5));
      } catch (e) {
        return result;
      }
    }
    return result;
  }
  return Future.error("Failed");
}

void showLocationSettings(context, {requestAlways = Geolocator.openLocationSettings}) {
  showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text("Location permissions not enabled!"),
            content: const Text(
                "Please enable location services and allow location permissions for this app in your device settings. Please restart the app afterwards."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Settings');
                  requestAlways();
                },
                child: const Text('Go to Settings'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ));
}

Future<List<Facility>> sortFacilities(permissionStatus) async {
  List<Facility> facilities = [...allFacilities];
  if (permissionStatus > 0) {
    try {
      await getUserLocation().then((pos) {
        facilities.sort((a, b) {
          double distanceForA = Geolocator.distanceBetween(
              pos.latitude, pos.longitude, a.lat, a.long);
          double distanceForB = Geolocator.distanceBetween(
              pos.latitude, pos.longitude, b.lat, b.long);
          return distanceForA.compareTo(distanceForB);
        });
      });
    } catch (e) {
    }
  }
  return facilities;
}

Future<List<dynamic>> getClosestFacility() async {
  List<Facility> facilities = [...allFacilities];
  try {
    var pos = await getUserLocation();
    facilities.sort((a, b) {
      double distanceForA = Geolocator.distanceBetween(
          pos.latitude, pos.longitude, a.lat, a.long);
      double distanceForB = Geolocator.distanceBetween(
          pos.latitude, pos.longitude, b.lat, b.long);
      return distanceForA.compareTo(distanceForB);
    });
    var facility = facilities[0];
    var distance = Geolocator.distanceBetween(pos.latitude, pos.longitude, facility.lat, facility.long);
    return [distance, facility];
  } catch(e) {
    return [];
  }
}
