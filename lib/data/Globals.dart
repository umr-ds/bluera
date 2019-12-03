import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/Message.dart';
import 'package:flutter/material.dart';

String localUser = "Distributed Systems";

ValueNotifier<List<ValueNotifier<Channel>>> channels = new ValueNotifier<List<ValueNotifier<Channel>>>(<ValueNotifier<Channel>>[]);
