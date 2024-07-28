import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../core/politecoder/Typo.dart';
import '../../../../core/res/values/Dimens.dart';
import '../../../../core/res/values/MColors.dart';
import '../../../../core/res/values/Styles.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/messages/text_message.dart';
import '../manager/chat_cubit.dart';
import 'common.dart';

class ChatMessageItem extends HookWidget {
  final Message message;

  const ChatMessageItem({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatPool = BlocProvider.of<ChatCubit>(context);
    final index = chatPool.messages.indexOf(message);

    return Directionality(
      textDirection: message.isMine ? TextDirection.ltr : TextDirection.rtl,
      child: Row(
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: Dimens.spaceM, horizontal: Dimens.spaceM),
            decoration: BoxDecoration(
              gradient: message.isMine
                  ? Styles.linearMineChatGradiant
                  : Styles.linearChatGradiant,
              borderRadius: message.isMine
                  ? BorderRadius.only(
                      topLeft: const Radius.circular(Dimens.appRadius),
                      topRight: const Radius.circular(Dimens.appRadius),
                      bottomLeft: const Radius.circular(Dimens.appRadius),
                      bottomRight: hasSenderUserMessage(chatPool, index)
                          ? const Radius.circular(Dimens.appRadius)
                          : Radius.zero,
                    )
                  : BorderRadius.only(
                      topLeft: const Radius.circular(Dimens.appRadius),
                      topRight: const Radius.circular(Dimens.appRadius),
                      bottomLeft: hasPreferUserMessage(chatPool, index)
                          ? const Radius.circular(Dimens.appRadius)
                          : Radius.zero,
                      bottomRight: const Radius.circular(Dimens.appRadius),
                    ),
            ),
            child: showTextMessage(context, message as TextMessage),
          ),
        ],
      ),
    );
  }

  Column showTextMessage(BuildContext context, TextMessage message) {
    return Column(
      crossAxisAlignment: this.message.isMine
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (message.attachments != null)
          if (message.attachments?.length == 1)
            message.attachments?.last.fileType == "image"
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimens.appRadius),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimens.appRadius),
                      child: CachedNetworkImage(
                        imageUrl: message.attachments?.last.dataUrl ?? "",
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                        errorWidget: (context, url, error) => Container(
                          padding: EdgeInsets.all(Dimens.spaceM),
                          decoration: BoxDecoration(
                            color: MColors.primaryColor2,
                          ),
                          child: Image.asset("assets/images/logo.png"),
                        ),
                      ),
                    ),
                  )
                // ? Image.network(message.attachments?.last.dataUrl ?? "",
                //     fit: BoxFit.cover,
                //     height: 150,
                //     width: 150, errorBuilder: (context, error, stackTrace) {
                //     return Image.asset("assets/images/logo.png");
                //   })
                : showVoiceMessage(context, message)
          else
            SizedBox(
              height: 150,
              width: 150,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 8.0,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                    (message.attachments?.length ?? 0) > 4
                        ? 4
                        : (message.attachments?.length ?? 0), (index) {
                  return Center(
                    child: message.attachments?[index].fileType == "image"
                        ? CachedNetworkImage(
                            imageUrl: message.attachments?[index].dataUrl ?? "",
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              padding: EdgeInsets.all(Dimens.spaceM),
                              decoration: BoxDecoration(
                                color: MColors.primaryColor2,
                              ),
                              child: Image.asset("assets/images/logo.png"),
                            ),
                          )
                        // ? Image.network(
                        //     message.attachments?[index].dataUrl ?? "",
                        //     fit: BoxFit.cover,
                        //     errorBuilder: (context, error, stackTrace) {
                        //       return Image.asset("assets/images/logo.png");
                        //     },
                        //   )
                        : const SizedBox(),
                  );
                }),
              ),
            ),
        Typo(
          text: message.text,
          color: message.isMine ? MColors.white : MColors.black,
          textAlign: message.isMine ? TextAlign.left : TextAlign.right,
        ),
        Row(
          children: [
            Typo(
              text: intl.DateFormat("MMM d  h:mm a").format(
                  DateTime.fromMillisecondsSinceEpoch(message.createdAt ?? 0)),
              color: message.isMine ? MColors.primaryColor5 : MColors.grey4,
              size: 10,
            ),
            SizedBox(
              width: Dimens.spaceS,
            ),
            if (this.message.status == Status.seen ||
                this.message.status == Status.delivered)
              Icon(
                Iconsax.check,
                color: MColors.primaryColor5,
                size: Dimens.iconSizeS,
              ),
            // if (this.message.status == Status.delivered)
            //   Icon(
            //     IcoMoon.checkes,
            //     color: MColors.primaryColor5,
            //     size: Dimens.iconSize,
            //   ),
            if (this.message.status == Status.sending)
              Icon(
                Iconsax.clock,
                color: MColors.primaryColor5,
                size: Dimens.iconSize,
              ),
          ],
        ),
      ],
    );
  }

  bool hasPreferUserMessage(ChatCubit chatPool, int index) {
    return ((chatPool.messages.length - 1 >= index + 1 &&
            chatPool.messages[index + 1].isMine) ||
        (this.message == chatPool.messages.last &&
            !chatPool.messages.last.isMine));
  }

  bool hasSenderUserMessage(ChatCubit chatPool, int index) {
    return ((chatPool.messages.length - 1 >= index + 1 &&
            !chatPool.messages[index + 1].isMine) ||
        (this.message == chatPool.messages.last &&
            chatPool.messages.last.isMine));
  }

  showVoiceMessage(BuildContext context, TextMessage message) {
    // message?.attachments?.last.dataUrl ?? ""
    return VoiceMessage(
      path: message.attachments?.last.dataUrl ?? "",
    );
  }
}

const defaultPlayerCount = 1;

enum PopupAction {
  add,
  remove,
}

class VoiceMessage extends StatefulWidget {
  final String path;

  VoiceMessage({required this.path});

  @override
  State<VoiceMessage> createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage> {
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    _audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Duration duration = Duration(seconds: 0);
  Duration position = Duration(seconds: 0);

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SeekBar(
          duration: duration,
          position: position,
          bufferedPosition: Duration(),
          onChanged: (value) {
            _audioPlayer.seek(value);
          },
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: Styles.linearMineChatGradiant,
          ),
          child: IconButton(
            onPressed: () async {
              print("player state: ${_audioPlayer.state}");

              if (isPlaying) {
                await _audioPlayer.pause();
                isPlaying = false;
              } else {
                if (isPlaying) return;
                await _audioPlayer.play(UrlSource(widget.path));
                isPlaying = true;
              }

              duration = (await _audioPlayer.getDuration())!;
              position = (await _audioPlayer.getCurrentPosition())!;

              setState(() {});
            },
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow_rounded,
              color: MColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
