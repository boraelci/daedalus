import 'package:daedalus/data/facility_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:daedalus/models/facility_model.dart';
import 'package:flutter/material.dart';

Future<bool> getLocationPermissions(context) async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showLocationSettings(context);
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    showLocationSettings(context);
    return false;
  }
  return true;
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Geolocator.openLocationSettings();

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission != LocationPermission.denied && permission != LocationPermission.deniedForever) {
    var result;
    try{
      result = Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 5));
    }
    catch (e) {
      try {
        result = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 5));
      }
      catch (e) {
        return result;
      }
    }
    return result;
  }
  return Future.error("Failed");
}

void showLocationSettings(context) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Location permissions not enabled!"),
        content: Text(
            "Please enable location services and allow location permissions for this app in your device settings. Please restart the app afterwards."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Settings');
              Geolocator.openLocationSettings();
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

Future<List<Facility>> localizeToUser() async {
  List<Facility> facilities = [...allFacilities];
  try {
    await determinePosition().then((pos) {
      facilities.sort((a, b) {
        double distanceForA = Geolocator.distanceBetween(
            pos.latitude, pos.longitude, a.lat, a.long);
        double distanceForB = Geolocator.distanceBetween(
            pos.latitude, pos.longitude, b.lat, b.long);
        return distanceForA.compareTo(distanceForB);
      });
    });
    return facilities;
  } catch (e) {
    return facilities;
  }
}