import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class ChatwootNewMessageRequest extends Equatable {
  @JsonKey()
  final String content;
  @JsonKey(name: "echo_id")
  final String echoId;
  @JsonKey()
  File? attachment;

  ChatwootNewMessageRequest(
      {required this.content, required this.echoId, this.attachment});

  @override
  List<Object> get props => [content, echoId];

  factory ChatwootNewMessageRequest.fromJson(Map<String, dynamic> json) {
    return ChatwootNewMessageRequest(
      content: json['content'] as String,
      echoId: json['echo_id'] as String,
    );
  }

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      'content': content,
      'echo_id': echoId,
    };
  }
}
