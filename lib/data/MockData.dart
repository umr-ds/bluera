import 'package:Bluera/data/Channel.dart';
import 'package:Bluera/data/Message.dart';
import 'package:Bluera/data/User.dart';

User localUser = new User("Distributed Systems", true);

final List<ChannelOverview> channelOverviews = <ChannelOverview>[
  ChannelOverview("Announcements", "Keep Calm"),
  ChannelOverview("Public Chat", "and use Bluera")
];

User other = new User("Verpeilte Systeme", false);
User third = new User("Anon", false);

List<Message> announceMessages = <Message>[
  Message(third, "Super"),
  Message(localUser, "Unterwegs"),
  Message(third, "Treffpunkt: Hof"),
  Message(other, "Achtung Feuer"),
];

List<Message> publicMessages = <Message>[
  Message(third, "toll"),
  Message(localUser, "Und ich erst."),
  Message(third, "Finde ich auch."),
  Message(other, "Ganz tolle Nachricht."),
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
