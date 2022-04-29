import 'dart:async';
import 'package:daedalus/data/facility_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:daedalus/models/facility_model.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_geofence/geofence.dart';

const locationDeniedTitle = "Location permissions are missing.";
const locationDeniedBody = "This app needs to access your location. Please go to your device settings and allow location permissions."; //When determining nearby facilities

const locationAlwaysTitle = "Location permissions have to be updated.";
const locationAlwaysBody = "This app needs to access your location in the background. Please go to 'Location Access For This App' in your device settings and select 'Allow all the time'. You may have to restart the app afterwards."; //For geolocation alert notifications

Future<void> showLocationSettings(context, title, body, onSettingsPressed) async {
  showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: <Widget>[
          TextButton(
            onPressed: () { onSettingsPressed(); },
            child: const Text('Go to Settings'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ));
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

Future<List<Facility>> sortFacilities(facilities) async {
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
    } catch (e) { ;  }
    return facilities;
}

// Same for IOS and Android
Future<void> requestLocationWhenInUse() async {
  await Permission.locationWhenInUse.request();
}

// Android: show dialog asking to allow always, On click allow run Permission.locationAlways.request();
// iOS ask directly
Future<void> requestLocationAlways(context) async {
  if (await Permission.locationAlways.isPermanentlyDenied) { handleLocationDenied(context); }
  else {
    if (Platform.isAndroid) {
      showLocationSettings(context, locationAlwaysTitle, locationAlwaysBody, Permission.locationAlways.request);
    }
    else {
      await Permission.locationAlways.request();
    }
  }
}

// Both Android and IOS show dialog to completely redirect to settings screen Geolocator.openLocationSettings();
void handleLocationDenied(context) {
  showLocationSettings(context, locationDeniedTitle, locationDeniedBody, Geolocator.openLocationSettings);
}

Future<int> getLocationPermissions(context, {curRetry = 0}) async {
  if (await Permission.locationAlways.isGranted) { return 2; }
  else if (await Permission.locationWhenInUse.isGranted) { await requestLocationAlways(context); }
  else if (await Permission.locationWhenInUse.isPermanentlyDenied){ handleLocationDenied(context); }
  else {
    if (curRetry < 1) {
      await requestLocationWhenInUse();
      return await getLocationPermissions(context, curRetry: (curRetry+1));
    }
    else { handleLocationDenied(context); }
  }

  if (await Permission.locationAlways.isGranted) { return 2; }
  else if (await Permission.locationWhenInUse.isGranted) { return 1; }
  else { return 0; }
}

void setupGeolocationAlerts(facilities, scheduleNotification, {radius = 500.0}) {
  Geofence.initialize();

  for (var facility in facilities.take(10)) {
    Geofence.addGeolocation(Geolocation(
        latitude: facility.lat,
        longitude: facility.long,
        radius: radius,
        id: facility.facid), GeolocationEvent.entry).then((value) { });
  }

  Geofence.startListening(GeolocationEvent.entry, (entry) {
    for (var facility in facilities) {
      if (facility.facid == entry.id) {
        scheduleNotification(facility);
        break;
      }
    }
  });
}

/*
void runPeriodicLocationCheck(facilities) {
  Timer.periodic(Duration(seconds: 5), (timer) {
    StreamSubscription<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ))
        .listen((pos) {
          print(Geolocator.distanceBetween(
          pos.latitude, pos.longitude, facilities[0].lat, facilities[0].long));
    });
  });
}*/