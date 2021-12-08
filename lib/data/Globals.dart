import 'package:bluera/data/Channel.dart';
import 'package:flutter/material.dart';
import 'package:bluera/data/Message.dart';

String usernameFileName = "username.txt";

String localUser = null;
ValueNotifier<String> localUserNotifier = new ValueNotifier(localUser);

ValueNotifier<List<ValueNotifier<Channel>>> channels =
    new ValueNotifier<List<ValueNotifier<Channel>>>(<ValueNotifier<Channel>>[]);

UserLocation currentLocation = UserLocation(longitude: 0, latitude: 0);
