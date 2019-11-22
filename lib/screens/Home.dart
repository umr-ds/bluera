import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Bluera/data/Channel.dart';
import 'package:Bluera/data/MockData.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Bluera"),
        backgroundColor: Color(0xFF0A3D91),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.add),
            onPressed: (){},
          ),
          new IconButton(icon: new Icon(Icons.settings),
            onPressed: (){},
          ),
        ],
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) =>
            ChannelOverviewItem(channelOverviews[index], context),
        itemCount: channelOverviews.length,
      ),
    );
  }
}
