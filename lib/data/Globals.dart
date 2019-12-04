import 'package:BlueRa/data/Channel.dart';
import 'package:flutter/material.dart';

String usernameFileName = "user.name";

String localUser;

ValueNotifier<List<ValueNotifier<Channel>>> channels = new ValueNotifier<List<ValueNotifier<Channel>>>(<ValueNotifier<Channel>>[]);
