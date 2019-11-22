import 'package:Bluera/data/Channel.dart';
import 'package:Bluera/data/Message.dart';
import 'package:Bluera/data/User.dart';

final List<ChannelOverview> channelOverviews = <ChannelOverview>[
  ChannelOverview("Announcements", "Keep Calm"),
  ChannelOverview("Public Chat", "and use Bluera")
];

User me = new User("Distributed Systems", true);
User other = new User("Verpeilte Systeme", false);
User third = new User("Anon", false);

List<Message> announceMessages = <Message>[
  Message(other, "Achtung Feuer"),
  Message(third, "Treffpunkt: Hof"),
  Message(me, "Unterwegs"),
  Message(third, "Super")
];

List<Message> publicMessages = <Message>[
  Message(other, "Ganz tolle Nachricht."),
  Message(third, "Finde ich auch."),
  Message(me, "Und ich erst."),
  Message(third, "toll")
];

Channel announcements = Channel("Announcements", announceMessages);
Channel publics = Channel("Public Chat", publicMessages);

List<Channel> channels = <Channel>[
  announcements,
  publics
];

Channel getChannel(String name) {
  for (final chan in channels) {
    if (chan.name == name) {
      return chan;
    }
  }

  return null;
}
