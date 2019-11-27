import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/Message.dart';
import 'package:BlueRa/data/User.dart';

User localUser = new User("Distributed Systems", true);

List<ChannelOverview> channelOverviews = <ChannelOverview>[
  ChannelOverview("Announcements", "Keep Calm"),
  ChannelOverview("Public Chat", "and use BlueRa")
];

List<ChannelOverview> notPartChannelOverviews = <ChannelOverview>[
  ChannelOverview("Random", ""),
  ChannelOverview("Help", ""),
  ChannelOverview("Cool Stuff", "")
];

User other = new User("Verpeilte Systeme", false);
User third = new User("Anon", false);

List<Message> announceMessages = <Message>[
  Message(third, "Super", "Announcements", "1574689628"),
  Message(localUser, "Unterwegs", "Announcements", "1574689728"),
  Message(third, "Treffpunkt: Hof", "Announcements", "1574689828"),
  Message(other, "Achtung Feuer", "Announcements", "1574689928"),
];

List<Message> publicMessages = <Message>[
  Message(third, "toll", "Public Chat", "1574689628"),
  Message(localUser, "Und ich erst.", "Public Chat", "1574689728"),
  Message(third, "Finde ich auch.", "Public Chat", "1574689828"),
  Message(other, "Ganz tolle Nachricht.", "Public Chat", "1574689928"),
];

Channel announcements = Channel("Announcements", announceMessages);
Channel publics = Channel("Public Chat", publicMessages);

Channel notPart1 = Channel("Random", new List<Message>());
Channel notPart2 = Channel("Help", new List<Message>());
Channel notPart3 = Channel("Cool Stuff", new List<Message>());

List<Channel> channels = <Channel>[
  announcements,
  publics
];

List<Channel> notPartChannels = <Channel>[
  notPart1,
  notPart2,
  notPart3
];

Channel getChannel(String name) {
  for (final chan in channels) {
    if (chan.name == name) {
      return chan;
    }
  }

  return null;
}

Channel getChannelFrom(String name, List<Channel> channelList) {
  for (final chan in channelList) {
    if (chan.name == name) {
      return chan;
    }
  }

  return null;
}

ChannelOverview getChannelOverviewFrom(String name, List<ChannelOverview> channelList) {
  for (final chan in channelList) {
    if (chan.name == name) {
      return chan;
    }
  }

  return null;
}
