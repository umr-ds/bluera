import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:BlueRa/main.adapter.g.m8.dart';
import 'package:BlueRa/data/Settings.g.m8.dart';

DatabaseProvider databaseProvider;
SettingsProxy settings;

LocationData currentLocation;

ChangeNotifier recvNotifier = ChangeNotifier();
