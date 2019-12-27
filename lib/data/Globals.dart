import 'package:BlueRa/data/Channel.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:BlueRa/main.adapter.g.m8.dart';

DatabaseProvider databaseProvider;

String usernameFileName = "user.name";

String localUser;

LocationData currentLocation;

ValueNotifier<void> channelUpdated = ValueNotifier<void>(null);
