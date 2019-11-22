import 'package:Bluera/data/Channel.dart';
import 'package:Bluera/data/Message.dart';
import 'package:Bluera/data/User.dart';

User localUser = new User("Distributed Systems", true);

List<ChannelOverview> channelOverviews = <ChannelOverview>[
  ChannelOverview("Announcements", "Keep Calm"),
  ChannelOverview("Public Chat", "and use Bluera")
];

List<ChannelOverview> notPartChannelOverviews = <ChannelOverview>[
  ChannelOverview("Random", ""),
  ChannelOverview("Help", ""),
  ChannelOverview("Cool Stuff", "")
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
