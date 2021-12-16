import 'package:flutter/material.dart';
import 'package:bluera/data/Message.dart';
import 'package:bluera/data/Channel.dart';
import 'package:bluera/data/Globals.dart';
import 'package:bluera/connectors/RF95.dart';
import 'package:bluera/connectors/Database.dart';
import 'package:bluera/connectors/Location.dart';
import 'package:location/location.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(this.channel);

  final ValueNotifier<Channel> channel;

  @override
  State createState() => new ChatScreenState(channel);
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  ChatScreenState(this.channel);

  ValueNotifier<Channel> channel;

  final TextEditingController _textController = new TextEditingController();

  bool _isComposing = false;

  final DBConnector dbHelper = DBConnector.instance;

  @override
  void dispose() {
    super.dispose();
  }

  Future _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    LocationData currentLocation = UserLocation.currentLocation;
    print(currentLocation);

    Message _msg = new Message(localUser, text, channel.value.name,
        DateTime.now().toUtc().millisecondsSinceEpoch.toString(), true, currentLocation);
    MessageItem messageItem = new MessageItem(
      message: _msg,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 100),
        vsync: this,
      ),
    );

    rf95.tx(_msg);

    setState(() {
      channel.value.messages.insert(0, _msg);
      dbHelper.update(channel.value.toMap());
    });
    messageItem.animationController.forward();
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
              channel.value.name,
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
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
              dbHelper.update(channel.value.toMap());
              channel.value.attending = false;
              channels.notifyListeners();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
              child: ValueListenableBuilder(
            valueListenable: channel,
            builder: (BuildContext context, Channel chan, Widget child) {
              return ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) {
                  Message _msg = channel.value.messages[index];
                  MessageItem _msgItm = new MessageItem(
                    message: _msg,
                    animationController: new AnimationController(
                      duration: new Duration(milliseconds: 100),
                      vsync: this,
                    ),
                  );
                  _msgItm.animationController.forward();
                  return _msgItm;
                },
                itemCount: channel.value.messages.length,
              );
            },
          )),
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
      data: new IconThemeData(color: Theme.of(context).colorScheme.secondary),
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
                decoration: new InputDecoration.collapsed(hintText: "Send a message"),
                maxLength: 250,
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                color: Color(0xFF0A3D91),
                icon: new Icon(Icons.send),
                onPressed: (_isComposing && rf95 != null) ? () => _handleSubmitted(_textController.text) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
