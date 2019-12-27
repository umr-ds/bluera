import 'dart:async';
import 'package:location/location.dart';
import 'package:BlueRa/data/Globals.dart';

class UserLocationStream {
  Location location = new Location();

  StreamController<LocationData> _locationController =
      StreamController<LocationData>();
  Stream<LocationData> get locationStream => _locationController.stream;

  void locationService() async {
    bool locationPermission = await location.hasPermission();
    if (!locationPermission) {
      location.requestPermission();
    }
    location.onLocationChanged().listen((locationData) {
      if (locationData != null) {
        currentLocation = locationData;
      }
    });
  }
}
