import 'package:location/location.dart';
import 'dart:async';
import 'package:BlueRa/data/Message.dart';
import 'package:BlueRa/data/Globals.dart';

class UserLocationStream {
  Location location = new Location();

  StreamController<UserLocation> _locationController = StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;

  void locationService() async {
    bool locationPermission = await location.hasPermission();
    if (!locationPermission) {
      location.requestPermission();
    }
    location.onLocationChanged().listen((locationData) {
      if (locationData != null) {
        currentLocation = UserLocation(
          latitude: locationData.latitude,
          longitude: locationData.longitude
        );
      }
    });
  }
}
