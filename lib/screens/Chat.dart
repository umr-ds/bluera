import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:BlueRa/data/Message.g.m8.dart';
import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/Globals.dart';
import 'package:BlueRa/connectors/RF95.dart';
import 'package:BlueRa/screens/MessageItem.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(this.channel);
  final Channel channel;

  ValueListenableBuilder b;

  @override
  State createState() => new ChatScreenState(channel);
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  ChatScreenState(this.channel);
  final Channel channel;

  bool _isComposing = false;
  final TextEditingController _textController = new TextEditingController();

  Future<List<MessageProxy>> getMessageProxies() async {
    var dbClient = await databaseProvider.db;
    var result = await dbClient.query(
      databaseProvider.theMessageTableHandler,
      columns: databaseProvider.theMessageColumns,
      where: "channel = ?",
      whereArgs: [channel.name],
      orderBy: "timestamp DESC",
    );

    return result.map((e) => MessageProxy.fromMap(e)).toList();
  }

  void _refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    recvNotifier.removeListener(this._refresh);
  }

  Future _handleSubmitted(String text) async {
    _textController.clear();
    _isComposing = false;

    MessageProxy _msg = MessageProxy(
      user: settings.user,
      text: text,
      channel: channel.name,
      timestamp_ms: DateTime.now().toUtc().millisecondsSinceEpoch,
      mine: true,
    );

    databaseProvider.saveMessage(_msg);
    rf95.send(_msg);
    recvNotifier.notifyListeners();
  }

  @override
  void initState() {
    super.initState();
    recvNotifier.addListener(this._refresh);
  }

  @override
  Widget build(BuildContext context) {
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
              // TODO: Fix state according to real BT connection
              rf95 == null ? "Not Connected" : "Connected",
              style: TextStyle(fontSize: 10.0),
            )
          ],
        ),
        backgroundColor: Color(0xFF0A3D91),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.open_in_new),
            onPressed: () {
              channel.attending = false;
              databaseProvider.updateChannel(channel);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: FutureBuilder(
              future: getMessageProxies(),
              builder: (context, snapshot) => ListView.builder(
                reverse: true,
                itemCount: snapshot.hasData ? snapshot.data.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  MessageItem _msgItm = MessageItem(
                    message: snapshot.data[index],
                    animationController: new AnimationController(
                      duration: new Duration(milliseconds: 100),
                      vsync: this,
                    ),
                  );
                  _msgItm.animationController.forward();
                  return _msgItm;
                },
              ),
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  if (!_isComposing) {
                    setState(() {
                      _isComposing = text.length > 0;
                    });
                  }
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
                maxLength: 250,
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                color: Color(0xFF0A3D91),
                icon: new Icon(Icons.send),
                onPressed: (_isComposing && rf95 != null)
                    ? () => _handleSubmitted(_textController.text)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
