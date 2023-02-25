import 'package:chatwoot_sdk/data/remote/responses/chatwoot_event.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../local_storage.dart';

part 'chatwoot_message.g.dart';

/// {@category FlutterClientSdk}
@JsonSerializable(explicitToJson: true)
@HiveType(typeId: CHATWOOT_MESSAGE_HIVE_TYPE_ID)
class ChatwootMessage extends Equatable {
  ///unique identifier of the message
  @JsonKey(fromJson: idFromJson)
  @HiveField(0)
  final int id;

  ///text content of the message
  @JsonKey()
  @HiveField(1)
  final String? content;

  ///type of message
  ///
  ///returns 1 if message belongs to contact making the request
  @JsonKey(name: "message_type", fromJson: messageTypeFromJson)
  @HiveField(2)
  final int? messageType;

  ///content type of message
  @JsonKey(name: "content_type")
  @HiveField(3)
  final String? contentType;

  @JsonKey(name: "content_attributes")
  @HiveField(4)
  final dynamic contentAttributes;

  ///date and time message was created
  @JsonKey(name: "created_at", fromJson: createdAtFromJson)
  @HiveField(5)
  final String createdAt;

  ///id of the conversation the message belongs to
  @JsonKey(name: "conversation_id", fromJson: idFromJson)
  @HiveField(6)
  final int? conversationId;

  ///list of media/doc/file attachment for message
  @JsonKey(name: "attachments")
  @HiveField(7)
  final List<Attachment>? attachments;

  ///The user this message belongs to
  @JsonKey(name: "sender")
  @HiveField(8)
  final ChatwootEventMessageUser? sender;

  ///checks if message belongs to contact making the request
  bool get isMine => messageType != 1;

  ChatwootMessage(
      {required this.id,
      required this.content,
      required this.messageType,
      required this.contentType,
      required this.contentAttributes,
      required this.createdAt,
      required this.conversationId,
      required this.attachments,
      required this.sender});

  factory ChatwootMessage.fromJson(Map<String, dynamic> json) {
    print("ChatwootMessage json : ${json}");
    return ChatwootMessage(
      id: idFromJson(json['id']),
      content: json['content'] as String?,
      messageType: messageTypeFromJson(json['message_type']),
      contentType: json['content_type'] as String?,
      contentAttributes: json['content_attributes'],
      createdAt: createdAtFromJson(json['created_at']),
      conversationId: idFromJson(json['conversation_id']),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      sender: json['sender'] == null
          ? null
          : ChatwootEventMessageUser.fromJson(
          json['sender'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => _$ChatwootMessageToJson(this);

  @override
  List<Object?> get props => [
        id,
        content,
        messageType,
        contentType,
        contentAttributes,
        createdAt,
        conversationId,
        attachments,
        sender
      ];
}

int idFromJson(value) {
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return value;
}

int messageTypeFromJson(value) {
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return value;
}

String createdAtFromJson(value) {
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value * 1000).toString();
  }
  return value.toString();
}

/// {@category FlutterClientSdk}
@HiveType(typeId: CHATWOOT_ATTACHMENT_HIVE_TYPE_ID)
@JsonSerializable(explicitToJson: true)
class Attachment {
  @JsonKey(fromJson: idFromJson)
  @HiveField(0)
  int? id;
  @JsonKey(name: "message_id", fromJson: idFromJson)
  @HiveField(1)
  int? messageId;
  @JsonKey(name: "file_type")
  @HiveField(2)
  String? fileType;
  @JsonKey(name: "account_id", fromJson: idFromJson)
  @HiveField(3)
  int? accountId;
  @JsonKey()
  @HiveField(4)
  String? extension;
  @JsonKey(name: "data_url")
  @HiveField(5)
  String? dataUrl;
  @JsonKey(name: "thumb_url")
  @HiveField(6)
  String? thumbUrl;
  @JsonKey()
  @HiveField(7)
  int? fileSize;

  Attachment(
      {this.id,
      this.messageId,
      this.fileType,
      this.accountId,
      this.extension,
      this.dataUrl,
      this.thumbUrl,
      this.fileSize});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    print("attachment json: $json");
    return Attachment()
      ..id = idFromJson(json['id'])
      ..messageId = idFromJson(json['message_id'])
      ..fileType = json['file_type'] as String?
      ..accountId = idFromJson(json['account_id'])
      ..extension = json['extension'] as String?
      ..dataUrl = json['data_url'] as String?
      ..thumbUrl = json['thumb_url'] as String?
      ..fileSize = json['fileSize'];
  }

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}
