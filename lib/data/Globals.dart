import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:BlueRa/main.adapter.g.m8.dart';

DatabaseProvider databaseProvider;

String usernameFileName = "user.name";

String localUser;

LocationData currentLocation;

ChangeNotifier recvNotifier = ChangeNotifier();
