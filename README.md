# BlueRa

BlueRa is a simple cross-platform app for connecting to a RF95 modem using Bluetooth and use the serial interface to chat over LoRa.



## Getting Started

At this point, there are no releases. Therefore, you have to build the app yourself.



To get started, you have to install Flutter. To do so, [please follow the official instructions.](https://flutter.dev/docs/get-started/install)

After that, continue with the following steps.



### Using an IDE

Currently, Flutter is available for [Android Studio](https://flutter.dev/docs/get-started/editor?tab=androidstudio) and [Visual Studio Code](https://flutter.dev/docs/get-started/editor?tab=vscode). Simply import the projekt to the IDE, connect your device with your computer and run the project. The IDE should handle all dependencies and signing for iOS and so on. If not, the error messages should be sufficient to track down the issue and solve it.



### Using the CLI

Flutter is also usable using the CLI. Therefore, connect your device with your computer, go to the project folder, get dependencies and install the app:



```shell
cd <path>/BlueRa
flutter pub get
flutter run
```



## Using the App

### First Start

On first start, you are asked to give yourself a username. After that, you will see an empty home screen. This is where your channels will appear.

You can also change your username by tapping the dots in the home screen and selecting "User Settings".



### Connect to Modem

In the top right corner, tap on the dots and select "Bluetooth Settings". Here, you have to connect to a RF95 Modem. Scan for available devices and connect to the found RF95 Modem.



### Add and Join Channels

On the home screen, tap the "+" button in the top right corner. If channels are available, you can join them by tapping on the name. You can also create own channels here.



### Changing LoRa Settings

By chosing "LoRa Settings" in the home screen, you can select one of four modes.



### Chatting

If you attend at least one channel, they will be shown on the home screen. Tap on a channel and you will be able to send messages to this channel. Note, that you have to be connected to a modem for chatting. The connection state is shown in the app bar on the top of the screen. By tapping the leave button in the top right corner of the chat screen, you can leave a channel.



## Knwon Issues

### Modem State Management

The connection state is somewhat whacky. If you encounter some problems with messages not or multiple times appearing, try to reconnect. I can also be helful to restart both, the app and the modem.



### User Management

The intended behaviour is to persist the local user. This seems to be broken as of now. It is possible that the app will ask you again for a user name for some reason.



### LoRa Settings

While it is possible to change the LoRa mode of the modem to one of the four possible options, there is currently no way to tell which mode is currently used.














