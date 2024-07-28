import 'dart:convert';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:bloc/bloc.dart';
import 'package:chatwoot_sdk/chatwoot_callbacks.dart';
import 'package:chatwoot_sdk/chatwoot_client.dart';
import 'package:chatwoot_sdk/data/local/entity/chatwoot_message.dart';
import 'package:chatwoot_sdk/data/local/entity/chatwoot_user.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../../../../main.dart' as main;
import '../../domain/entities/message.dart';
import '../../domain/entities/messages/image_message.dart';
import '../../domain/entities/messages/text_message.dart';
import '../../domain/entities/chat_user.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatwootClient? _client;

  ChatwootClient? get client => _client;
  late ChatUser chatUser;

  final idGen = const Uuid();

  ChatCubit() : super(ChatInitial()) {

    chatUser = const ChatUser(
      id: "09135646251",
      firstName: "محمد",
      imageUrl: "-",
    );
  }

  List<Message> _messages = [];

  List<Message> get messages => _messages;
  bool conversationIsTyping = false;

  final scrollCntroller = ScrollController();

  initial() async {
    final chatwootCallbacks = ChatwootCallbacks(
      onConversationIsOffline: () {
      },
      onConversationIsOnline: () {
      },
      onConversationResolved: () {
      },
      onWelcome: () {
      },
      onPing: () {
      },
      onConfirmedSubscription: () {
        emit(ChatLoading());
        emit(ChatLoaded());
      },
      onConversationStartedTyping: () {
        emit(ChatLoading());
        conversationIsTyping = true;
        emit(ChatLoaded());
      },
      onConversationStoppedTyping: () {
        emit(ChatLoading());
        conversationIsTyping = false;
        emit(ChatLoaded());
      },
      onPersistedMessagesRetrieved: (persistedMessages) {
        emit(ChatLoading());
        _messages = persistedMessages
            .map((message) => chatwootToTextMessage(message))
            .toList();

        emit(ChatLoaded());
      },
      onMessagesRetrieved: (messages) {
        if (messages.isEmpty) {
          return;
        }
        emit(ChatLoading());
        final chatMessages =
            messages.map((message) => chatwootToTextMessage(message)).toList();
        final mergedMessages =
            <Message>[..._messages, ...chatMessages].toSet().toList();
        final now = DateTime.now().millisecondsSinceEpoch;
        mergedMessages.sort((a, b) {
          return (b.createdAt ?? now).compareTo(a.createdAt ?? now);
        });
        _messages = mergedMessages;

        emit(ChatLoaded());
      },
      onMessageReceived: (chatwootMessage) {
        emit(ChatLoading());
        _messages.insert(0, chatwootToTextMessage(chatwootMessage));
        emit(ChatLoaded());
      },
      onMessageDelivered: (chatwootMessage, echoId) {
        emit(ChatLoading());

        TextMessage textMessage =
            chatwootToTextMessage(chatwootMessage, echoId: echoId);

        handleMessageSent(textMessage, echoId: echoId);

        emit(ChatLoaded());
      },
      onMessageSent: (chatwootMessage, echoId) async {
        emit(ChatLoading());

        final message = TextMessage(
          isMine: chatwootMessage.isMine,
          id: chatwootMessage.id.toString(),
          author: chatUser,
          text: chatwootMessage.content ?? "",
          status: Status.delivered,
          attachments: chatwootMessage.attachments,
        );

        handleMessageSent(message, echoId: echoId);

        emit(ChatLoaded());
      },
      onMessageUpdated: (chatwootMessage) async {
        emit(ChatLoading());
        await handleMessageUpdated(chatwootToTextMessage(chatwootMessage,
            echoId: chatwootMessage.id.toString()));
        emit(ChatLoaded());
      },
      onError: (error) {
      },
    );

    emit(ChatLoading());
    try {
      ChatwootClient.create(
        baseUrl: "https://a22b.stage.alshafagh.ir",
        inboxIdentifier: "hds3D5XyKoSqLkF4beyT7sH1",
        // user: ChatwootUser(
        //   identifierHash: _authCubit.customer?.mobile ?? await _getId(),
        //   //todo the identifire just accept email
        //   identifier: "Mohammad@gmail.com",
        //   name: "Akbari",
        //   email: "Mohammad@gmail.com",
        // ),
        user: ChatwootUser(
          // identifierHash: (await _getId()) ?? "identifierHash",
          identifierHash: base64Encode("09135646251".codeUnits),
          identifier: "09135646251",
          name: "PoliteCoder",
          email: "Mohammad@gmail.com",
        ),
        enablePersistence: true,
        callbacks: chatwootCallbacks,
      ).then((client) async {
        logger.i("client connected: ${client.user?.identifierHash}");
        _client = client;
        _client?.loadMessages();
        emit(ChatLoaded());
      }).catchError((e) {
        logger.e(e);
      });
    } catch (e) {
      logger.e(e);
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = const AndroidId();
      return await androidDeviceInfo.getId(); // unique ID on Android
    }

    final webInfo = await deviceInfo.webBrowserInfo;
    return webInfo.appCodeName;
  }

  handleMessageUpdated(Message message) {
    final index = _messages.indexWhere((element) {
      return element.id == message.id;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _messages[index] = message;
    });
  }

  void handleMessageSent(Message message, {String? echoId}) {
    final index = _messages.indexWhere((element) {
      if (echoId != null) {
        return element.id == echoId;
      }
      return element.id == message.id;
    });

    if (index == -1) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _messages[index] = message;
    });
  }

  addMessage(Message message) {
    print("------- add message called --------");
    emit(ChatLoading());
    if (!_messages.contains(message)) _messages.insert(0, message);
    emit(ChatLoaded());
  }

  TextMessage chatwootToTextMessage(ChatwootMessage chatMessage,
      {String? echoId}) {
    String? avatarUrl =
        chatMessage.sender?.avatarUrl ?? chatMessage.sender?.thumbnail;

    //Sets avatar url to null if its a gravatar not found url
    //This enables placeholder for avatar to show
    if (avatarUrl?.contains("?d=404") ?? false) {
      avatarUrl = null;
    }

    TextMessage message = TextMessage(
        isMine: chatMessage.isMine,
        id: echoId ?? chatMessage.id.toString(),
        author: chatMessage.isMine
            ? chatUser
            : ChatUser(
                id: chatMessage.sender?.id.toString() ?? const Uuid().v4(),
                firstName: chatMessage.sender?.name,
                imageUrl: avatarUrl,
              ),
        text: chatMessage.content ?? "",
        status: Status.seen,
        attachments: chatMessage.attachments,
        createdAt:
            DateTime.parse(chatMessage.createdAt).millisecondsSinceEpoch);
    return message;
  }

  ImageMessage chatwootToImageMessage(ChatwootMessage chatMessage,
      {String? echoId}) {
    String? avatarUrl =
        chatMessage.sender?.avatarUrl ?? chatMessage.sender?.thumbnail;

    //Sets avatar url to null if its a gravatar not found url
    //This enables placeholder for avatar to show
    if (avatarUrl?.contains("?d=404") ?? false) {
      avatarUrl = null;
    }

    ImageMessage message = ImageMessage(
        name: "",
        size: 0,
        uri: "",
        isMine: chatMessage.isMine,
        id: echoId ?? chatMessage.id.toString(),
        author: chatMessage.isMine
            ? chatUser
            : ChatUser(
                id: chatMessage.sender?.id.toString() ?? const Uuid().v4(),
                firstName: chatMessage.sender?.name,
                imageUrl: avatarUrl,
              ),
        status: Status.seen,
        createdAt:
            DateTime.parse(chatMessage.createdAt).millisecondsSinceEpoch);
    return message;
  }
}
