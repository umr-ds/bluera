import 'package:bluera/connectors/Location.dart';
import 'package:bluera/data/Channel.dart';
import 'package:bluera/data/Globals.dart';
import 'package:bluera/data/Message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

    // var marker = Marker();
    // marker.key.

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
              channel.name,
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
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://api.mapbox.com/styles/v1/"
                "{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoiaG9lY2hzdCIsImEiOiJja3hqMzJrdmIxaXpmMnZucGF2MjZzYzB2In0.i2MSdkm09lLcTZ6JLvDBFQ',
              'id': 'mapbox/streets-v11',
            },
          ),
          new MarkerLayerOptions(markers: markers),
        ],
      ),
    );
  }
}
