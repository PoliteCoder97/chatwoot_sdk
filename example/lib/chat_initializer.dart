import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:chatwoot_sdk/chatwoot_callbacks.dart';
import 'package:chatwoot_sdk/chatwoot_client.dart';
import 'package:chatwoot_sdk/data/local/entity/chatwoot_user.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'main.dart';

class ChatInitializer {
  static initial() async {
    final chatwootCallbacks = ChatwootCallbacks(
      onConversationIsOffline: () {
        logger.i("------- on conversation is offline --------");
      },
      onConversationIsOnline: () {
        logger.i("------- on conversation is online --------");
      },
      onConversationResolved: () {
        logger.i("------- on conversation resolved --------");
      },
      onWelcome: () {
        logger.i("------- welcome --------");
      },
      onPing: () {
        logger.i("------- on ping --------");
      },
      onConfirmedSubscription: () {
        logger.i("------- on confirmed subscription --------");
      },
      onConversationStartedTyping: () {
        logger.i("------- on conversation started typing --------");
      },
      onConversationStoppedTyping: () {
        logger.i("------- on conversation stopped typing --------");
      },
      onPersistedMessagesRetrieved: (persistedMessages) {
        logger.i(
            "------- persisted messages retrieved, persistedMessages: $persistedMessages --------");
      },
      onMessagesRetrieved: (messages) {
        logger.i(
            "------- on message retreived called, messages: $messages --------");
      },
      onMessageReceived: (chatwootMessage) {
        logger.i(
            "------- on message received called, chatwootMessage: $chatwootMessage --------");
      },
      onMessageSent: (chatwootMessage, echoId) async {
        logger.i(
            "------- on message sent called,chatwootMessage: $chatwootMessage --------");
      },
      onMessageUpdated: (chatwootMessage) async {
        logger.i("onMessageUpdated, message: ${chatwootMessage.toString()}");
      },
      onError: (error) {
        logger.e("Ooops! Something went wrong. Error Cause: ${error.cause}");
      },
    );
    try {
      ChatwootClient.create(
        baseUrl: "https://a22b.stage.alshafagh.ir",
        inboxIdentifier: "hds3D5XyKoSqLkF4beyT7sH1",
        // user: ChatwootUser(
        //   identifierHash: await _getId(),
        //   identifier: "Mohammad@gmail.com",
        //   name: "Akbari",
        //   email: "Mohammad@gmail.com",
        // ),
        user: ChatwootUser(
          identifierHash: (await _getId()) ?? "identifierHash",
          identifier: "09135646251",
          name: "PoliteCoder",
          email: "Mohammad@gmail.com",
        ),
        enablePersistence: true,
        callbacks: chatwootCallbacks,
      ).then((client) async {
        logger.i("client connected: ${client.user?.identifierHash}");
      }).catchError((e) {
        logger.e(e);
      });
    } catch (e) {
      logger.e(e);
    }
  }

  static Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = const AndroidId();
      return await androidDeviceInfo.getId(); // unique ID on Android
    }

    final webInfo = await deviceInfo.webBrowserInfo;
    return webInfo.appCodeName;
  }
}
