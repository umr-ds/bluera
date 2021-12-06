import 'package:location/location.dart';
import 'dart:async';
import 'package:bluera/data/Message.dart';
import 'package:bluera/data/Globals.dart';

class UserLocationStream {
  Location location = new Location();

  void initLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      location.requestService();
    }

    PermissionStatus locationPermission = await location.hasPermission();
    if (locationPermission == PermissionStatus.denied) {
      location.requestPermission();
    }
  }

  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;

  void locationService() async {
    bool serviceEnabled = await location.serviceEnabled();
    PermissionStatus locationPermission = await location.hasPermission();

    if (!serviceEnabled || locationPermission == PermissionStatus.denied) {
      return;
    }

    location.onLocationChanged.listen((locationData) {
      if (locationData != null) {
        currentLocation = UserLocation(
            latitude: locationData.latitude, longitude: locationData.longitude);
      }
    });
  }
}
