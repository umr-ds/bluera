import 'package:location/location.dart';

class UserLocation {
  static final Location location = new Location();
  static LocationData currentLocation;

  void initLocationService() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      await location.requestService();
    }

    PermissionStatus locationPermission = await location.hasPermission();
    if (locationPermission == PermissionStatus.denied) {
      await location.requestPermission();
    }

    // update currentLocation async and write into static currentLocation variable
    location.onLocationChanged.listen((locationData) {
      currentLocation = locationData;
    });
  }
}
