import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'global_variable.dart';



class LocationService {
  List<String> locationDetails = [];
  String lat = "";
  String lon = "";
  String address = "";
  Future<List<String>> getLocation() async {
    locationDetails.clear();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      log("location Denied");
      LocationPermission ask = await Geolocator.requestPermission();
      locationDetails;
    } else {
      locationDetails.clear();
      Position curerntPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      log("latitude ${curerntPosition.latitude.toString()}");
      log("longitude ${curerntPosition.longitude.toString()}");
      print("longitude ${curerntPosition.longitude.toString()}");
      lat = curerntPosition.latitude.toString();
      lon = curerntPosition.longitude.toString();
      locationDetails.add(lat);
      locationDetails.add(lon);

      List<Placemark> result = await placemarkFromCoordinates(
          curerntPosition.latitude.toDouble(),
          curerntPosition.longitude.toDouble());
      if (result.isNotEmpty) {
        address =
            "${result[0].locality},${result[0].administrativeArea},${result[0].country}";
        locationDetails.add(address);
      } else {
        address = "null";
      }
    }
    return locationDetails;
  }

  Future<void> locationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      log("location Denied");
      LocationPermission ask = await Geolocator.requestPermission();
      isLocationPermissionEnable = false;
    } else {
      isLocationPermissionEnable = true;
    }
  }
}
