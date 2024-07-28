import 'package:chatwoot_sdk/chatwoot_sdk.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../message.dart';
import '../preview_data.dart' show PreviewData;
import '../chat_user.dart' show ChatUser;

/*
{
  "identifier": "{\"channel\":\"RoomChannel\",\"pubsub_token\":\"PocPQoWTGdVvSggRBK5zySkH\"}",
  "message": {
    "event": "message.created",
    "data": {
      "id": 34,
      "content": "salam Mamad",
      "account_id": 2,
      "inbox_id": 2,
      "conversation_id": 3,
      "message_type": 1,
      "created_at": 1676897898,
      "updated_at": "2023-02-20T12:58:18.401Z",
      "private": false,
      "status": "sent",
      "source_id": null,
      "content_type": "text",
      "content_attributes": {},
      "sender_type": "User",
      "sender_id": 3,
      "external_source_ids": {},
      "additional_attributes": {},
      "label_list": null,
      "conversation": {
        "assignee_id": 3,
        "unread_count": 0
      },
      "echo_id": "b9f40412491f",
      "sender": {
        "id": 3,
        "name": "اکبری",
        "available_name": "اکبری",
        "avatar_url": "",
        "type": "user",
        "availability_status": "online",
        "thumbnail": ""
      },
      "performer": {
        "id": 3,
        "name": "اکبری",
        "available_name": "اکبری",
        "avatar_url": "",
        "type": "user",
        "availability_status": "online",
        "thumbnail": ""
      }
    }
  }
}
* */

/// A class that represents text message.
@immutable
abstract class TextMessage extends Message {
  /// Creates a text message.
  const TextMessage._({
    required super.isMine,
    required super.author,
    super.createdAt,
    required super.id,
    super.metadata,
    this.previewData,
    this.attachments,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    super.status,
    required this.text,
    MessageType? type,
    super.updatedAt,
  }) : super(type: type ?? MessageType.text);

  const factory TextMessage({
    required bool isMine,
    required ChatUser author,
    int? createdAt,
    required String id,
    Map<String, dynamic>? metadata,
    PreviewData? previewData,
    String? remoteId,
    Message? repliedMessage,
    String? roomId,
    bool? showStatus,
    Status? status,
    required String text,
    List<Attachment>? attachments,
    MessageType? type,
    int? updatedAt,
  }) = _TextMessage;

  /// Creates a text message from a map (decoded JSON).
  factory TextMessage.fromJson(Map<String, dynamic> json) {
    return TextMessage(isMine: json["isMine"] ?? false, author: ChatUser(id: ""), id: "id", text: "text");
  }

  /// See [PreviewData].
  final PreviewData? previewData;

  /// User's message.
  final String text;

  final List<Attachment>? attachments;

  /// Equatable props.
  @override
  List<Object?> get props => [
        author,
        createdAt,
        id,
        metadata,
        previewData,
        remoteId,
        repliedMessage,
        roomId,
        showStatus,
        status,
        text,
        updatedAt,
      ];

  @override
  Message copyWith({
    bool isMine = false,
    ChatUser? author,
    int? createdAt,
    String? id,
    Map<String, dynamic>? metadata,
    PreviewData? previewData,
    String? remoteId,
    Message? repliedMessage,
    String? roomId,
    bool? showStatus,
    Status? status,
    String? text,
    int? updatedAt,
  });

  /// Converts a text message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

/// A utility class to enable better copyWith.
class _TextMessage extends TextMessage {
  const _TextMessage({
    required super.isMine,
    required super.author,
    super.createdAt,
    required super.id,
    super.metadata,
    super.previewData,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    super.status,
    super.attachments,
    required super.text,
    super.type,
    super.updatedAt,
  }) : super._();

  @override
  Message copyWith({
    bool isMine = false,
    ChatUser? author,
    dynamic createdAt = _Unset,
    String? id,
    List<Attachment>? attachments,
    dynamic metadata = _Unset,
    dynamic previewData = _Unset,
    dynamic remoteId = _Unset,
    dynamic repliedMessage = _Unset,
    dynamic roomId,
    dynamic showStatus = _Unset,
    dynamic status = _Unset,
    String? text,
    dynamic updatedAt = _Unset,
  }) =>
      _TextMessage(
        isMine:  isMine,
        author: author ?? this.author,
        createdAt: createdAt == _Unset ? this.createdAt : createdAt as int?,
        id: id ?? this.id,
        metadata: metadata == _Unset
            ? this.metadata
            : metadata as Map<String, dynamic>?,
        previewData: previewData == _Unset
            ? this.previewData
            : previewData as PreviewData?,
        attachments: this.attachments,
        remoteId: remoteId == _Unset ? this.remoteId : remoteId as String?,
        repliedMessage: repliedMessage == _Unset
            ? this.repliedMessage
            : repliedMessage as Message?,
        roomId: roomId == _Unset ? this.roomId : roomId as String?,
        showStatus:
            showStatus == _Unset ? this.showStatus : showStatus as bool?,
        status: status == _Unset ? this.status : status as Status?,
        text: text ?? this.text,
        updatedAt: updatedAt == _Unset ? this.updatedAt : updatedAt as int?,
      );
}

class _Unset {}
