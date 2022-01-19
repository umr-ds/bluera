import 'package:bluera/connectors/Location.dart';
import 'package:bluera/data/Channel.dart';
import 'package:bluera/data/Globals.dart';
import 'package:bluera/data/Message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:intl/intl.dart';

class ChatMapScreen extends StatelessWidget {
  final Channel channel;

  const ChatMapScreen({Key key, this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var markers = [
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(UserLocation.currentLocation.latitude, UserLocation.currentLocation.longitude),
        key: Key(localUser),
        builder: (ctx) => new Container(
          child: Icon(
            Icons.gps_fixed,
            color: Colors.blueAccent,
          ),
        ),
      ),
    ];

    /// Used to trigger showing/hiding of popups.
    final PopupController _popupLayerController = PopupController();

    for (Message msg in channel.messages) {
      // if a marker for the user already exits, skip this message
      if (!markers.where((Marker m) => m.key == Key(msg.user)).isEmpty) {
        continue;
      }

      // add a marker for first new users
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(msg.location.latitude, msg.location.longitude),
          key: Key(msg.user),
          builder: (ctx) => new Container(
            child: Icon(
              Icons.gps_fixed_outlined,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Channel: ${channel.name}",
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              "User Locations",
              style: TextStyle(fontSize: 10.0),
            )
          ],
        ),
        backgroundColor: Color(0xFF0A3D91),
      ),
      body: FlutterMap(
        options: new MapOptions(
          center: LatLng(UserLocation.currentLocation.latitude, UserLocation.currentLocation.longitude),
          zoom: 13.0,
          onTap: (TapPos, LatLon) => _popupLayerController.hideAllPopups(), // Hide popup when the map is tapped.
        ),
        children: [
          TileLayerWidget(
            options: TileLayerOptions(
              urlTemplate: "https://api.mapbox.com/styles/v1/"
                  "{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
              additionalOptions: {
                'accessToken':
                    'pk.eyJ1IjoiaG9lY2hzdCIsImEiOiJja3hqMzJrdmIxaXpmMnZucGF2MjZzYzB2In0.i2MSdkm09lLcTZ6JLvDBFQ',
                'id': 'mapbox/streets-v11',
              },
            ),
          ),
          PopupMarkerLayerWidget(
            options: PopupMarkerLayerOptions(
                popupController: _popupLayerController,
                markers: markers,
                markerRotateAlignment: PopupMarkerLayerOptions.rotationAlignmentFor(AnchorAlign.top),
                popupBuilder: (BuildContext context, Marker marker) {
                  for (Message msg in channel.messages) {
                    if (Key(msg.user) == marker.key) {
                      return UserPopup(msg: msg);
                    }
                  }
                  return UserPopup();
                }),
          ),
        ],
      ),
    );
  }
}

class UserPopup extends StatelessWidget {
  final Message msg;
  const UserPopup({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Distance distance = new Distance();
    final double distance_meter = distance(new LatLng(msg.location.latitude, msg.location.longitude),
        new LatLng(UserLocation.currentLocation.latitude, UserLocation.currentLocation.longitude));

    return Container(
      width: 250,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'User: ${msg.user}',
                overflow: TextOverflow.fade,
                softWrap: false,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
              Text(
                'Last message received ${msg.timestampString} from ${distance_meter} m away:',
                textAlign: TextAlign.right,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
              Text(
                msg.text,
                style: TextStyle(fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      ),
    );
  }
}
