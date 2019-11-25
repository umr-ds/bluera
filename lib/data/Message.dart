import 'package:flutter/material.dart';
import 'package:BlueRa/data/User.dart';

class Message {
  Message(this.user, this.text);

  final User user;
  final String text;
}

class MessageItem extends StatelessWidget {
  MessageItem({this.message, this.animationController});

  final Message message;
  final AnimationController animationController;

List<Widget> buildMessageRow(BuildContext context) {
  if (message.user.isLocalUser) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(message.user.name, style: Theme.of(context).textTheme.subhead),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(message.text),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(child: new Text(message.user.name[0])),
      ),
    ];
  } else {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(child: new Text(message.user.name[0])),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(message.user.name, style: Theme.of(context).textTheme.subhead),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(message.text),
            ),
          ],
        ),
      ),
    ];
  }
}

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut
        ),
        axisAlignment: 0.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildMessageRow(context),
          ),
        ));
  }
}
