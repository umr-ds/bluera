import 'package:location/location.dart';
import 'dart:async';
import 'package:BlueRa/data/Message.dart';
import 'package:BlueRa/data/Globals.dart';

class UserLocationStream {
  Location location = new Location();

  void initLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      location.requestService();
    }

    bool locationPermission = await location.hasPermission();
    if (!locationPermission) {
      location.requestPermission();
    }
  }

  StreamController<UserLocation> _locationController = StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;

  void locationService() async {
    bool serviceEnabled = await location.serviceEnabled();
    bool locationPermission = await location.hasPermission();

    if (!serviceEnabled || !locationPermission) {
      return;
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
