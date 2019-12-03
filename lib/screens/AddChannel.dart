import 'package:flutter/material.dart';
import 'package:BlueRa/data/MockData.dart';
import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/Message.dart';

class AddChannelDialog extends StatefulWidget {
  @override
  AddChannelDialogState createState() => new AddChannelDialogState();
}

class AddChannelDialogState extends State<AddChannelDialog> {
  TextEditingController _channelNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Join channel"),
          backgroundColor: Color(0xFF0A3D91),
        ),
        body: new Padding(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: new ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemBuilder: (BuildContext context, int index) =>
                      AddChannelOverviewItem(notPartChannels.value[index].value),
                  itemCount: notPartChannels.value.length,
                ),
              ),
              new Divider(color: Color(0xFF000000)),
              new TextField(
                controller: _channelNameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Create new channel'
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new RaisedButton(
                      onPressed: () {
                        ValueNotifier<Channel> _chn = ValueNotifier(Channel(_channelNameController.text, new List<Message>()));
                        channels.value.add(_chn);
                        channels.notifyListeners();
                        Navigator.pop(context);
                      },
                    child: new Text("Create"),
                  ))
                ],
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
        ));
  }
}
