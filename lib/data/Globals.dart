import 'package:bluera/data/Channel.dart';
import 'package:flutter/material.dart';

String localUser = null;
ValueNotifier<String> localUserNotifier = new ValueNotifier(localUser);

ValueNotifier<List<ValueNotifier<Channel>>> channels =
    new ValueNotifier<List<ValueNotifier<Channel>>>(<ValueNotifier<Channel>>[]);
