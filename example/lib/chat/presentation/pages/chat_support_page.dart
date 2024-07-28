import 'dart:async';
import 'dart:io';

import 'package:chatwoot_sdk/chatwoot_client.dart';
import 'package:example/core/extentions/StringExtentions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

import 'package:uuid/uuid.dart';

import '../../../../core/politecoder/Typo.dart';
import '../../../../core/politecoder/openDialog.dart';
import '../../../../core/res/values/Dimens.dart';
import '../../../../core/res/values/MColors.dart';
import '../../../../main.dart';
import '../../../core/classes/Strings.dart';
import '../../../core/politecoder/OutlinAppButton.dart';
import '../../../core/politecoder/my_safe_area.dart';
import '../../../core/res/values/Styles.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/messages/text_message.dart';
import '../manager/chat_cubit.dart';
import '../widgets/chat_message_item.dart';
import '../widgets/confirm_chat_file_dialog.dart';
import '../widgets/confirm_chat_image_dialog.dart';

const theSource = AudioSource.microphone;

class ChatSupportPage extends HookWidget {
  final String userIdentifire;

  ChatSupportPage(this.userIdentifire, {super.key});

  Codec _codec = Codec.aacMP4;

  Future<void> openTheRecorder(ValueNotifier<FlutterSoundRecorder> recorder,
      ValueNotifier<bool> recorderIsInitialed) async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await recorder.value.openRecorder();
    if (!await recorder.value.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      if (!await recorder.value.isEncoderSupported(_codec) && kIsWeb) {
        recorderIsInitialed.value = true;
        return;
      }
    }
    // final session = await AudioSession.instance;
    // await session.configure(AudioSessionConfiguration(
    //   avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
    //   avAudioSessionCategoryOptions:
    //       AVAudioSessionCategoryOptions.allowBluetooth |
    //           AVAudioSessionCategoryOptions.defaultToSpeaker,
    //   avAudioSessionMode: AVAudioSessionMode.spokenAudio,
    //   avAudioSessionRouteSharingPolicy:
    //       AVAudioSessionRouteSharingPolicy.defaultPolicy,
    //   avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
    //   androidAudioAttributes: const AndroidAudioAttributes(
    //     contentType: AndroidAudioContentType.speech,
    //     flags: AndroidAudioFlags.none,
    //     usage: AndroidAudioUsage.voiceCommunication,
    //   ),
    //   androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
    //   androidWillPauseWhenDucked: true,
    // ));

    recorderIsInitialed.value = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record(ValueNotifier<FlutterSoundRecorder> recorder, String path) {
    recorder.value
        .startRecorder(
          toFile: path,
          codec: _codec,
          audioSource: theSource,
        )
        .then((value) {});
  }

  Future<String?> stopRecorder(ValueNotifier<FlutterSoundRecorder> recorder,
      ValueNotifier<bool> playbackIsReady) async {
    final recorderFileValue = await recorder.value.stopRecorder();
    playbackIsReady.value = true;

    if (recorderFileValue == null) return null;

    return recorderFileValue;
  }

  void play(
      ValueNotifier<FlutterSoundPlayer> player,
      ValueNotifier<FlutterSoundRecorder> recorder,
      String path,
      ValueNotifier<bool> playbackIsInitilied,
      ValueNotifier<bool> playbackIsReady) {
    assert(playbackIsInitilied.value &&
        playbackIsReady.value &&
        recorder.value.isStopped &&
        player.value.isStopped);
    player.value
        .startPlayer(
            fromURI: path,
            //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {})
        .then((value) {});
  }

  void stopPlayer(FlutterSoundPlayer player) {
    player.stopPlayer().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    final chatPool = BlocProvider.of<ChatCubit>(context);

    final hasUserTyped = useState(false);
    final hasMicLongPressed = useState(false);
    final hasAttacheFilePressed = useState(false);

    final showGuestDialog = useState(true);

    final selectedFile = useState<File?>(null);

    final messageController = useTextEditingController();

    messageController.addListener(() {
      if (messageController.text.isNotEmpty) {
        hasUserTyped.value = true;
      } else {
        hasUserTyped.value = false;
      }
    });

    XFile? recieptImage;
    final imagePicker = ImagePicker();

    final mPlayer = useState(FlutterSoundPlayer(logLevel: Level.off));
    final mRecorder = useState(FlutterSoundRecorder(logLevel: Level.off));
    final mPlayerIsInited = useState(false);
    final mRecorderIsInited = useState(false);
    final mplaybackReady = useState(false);

    final isInitial = useState(false);

    useMemoized(() {
      chatPool.initial();
    });

    useEffect(() {
      if (!isInitial.value) {
        isInitial.value = true;
        mPlayer.value.openPlayer().then((value) {
          mPlayerIsInited.value = true;
        });

        openTheRecorder(mRecorder, mRecorderIsInited).then((value) {
          mRecorderIsInited.value = true;
        });
      }
      return () {};
    });

    final timeCounter = useState(0);
    final timer = useState<Timer?>(null);

    final hasRecordVoiceCanceled = useState(false);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MColors.grey6,
        appBar: buildAppBar(context),
        body: MySafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Stack(
                children: [
                  BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      if (chatPool.messages.isEmpty) {
                        return buildEmptyChat();
                      }

                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        chatPool.scrollCntroller.animateTo(
                          chatPool.scrollCntroller.position.minScrollExtent,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeOut,
                        );
                      });

                      return buildChat(chatPool);
                    },
                  ),
                ],
              )),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(Dimens.spaceM),
                    decoration: BoxDecoration(
                      color: MColors.primaryColor4,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimens.appRadius),
                          topRight: Radius.circular(Dimens.appRadius)),
                    ),
                    child: Column(
                      children: [
                        // SizedBox(height: 50),
                        if (hasAttacheFilePressed.value)
                          SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                buildSelectImageFromGallery(
                                    hasAttacheFilePressed,
                                    recieptImage,
                                    imagePicker,
                                    selectedFile,
                                    context,
                                    chatPool,
                                    messageController),
                                const SizedBox(
                                  width: Dimens.spaceM,
                                ),
                                buildSelectFile(
                                    hasAttacheFilePressed,
                                    selectedFile,
                                    context,
                                    chatPool,
                                    messageController),
                                const SizedBox(
                                  width: Dimens.spaceM,
                                ),
                                buildSelectImageFromCamera(
                                    hasAttacheFilePressed,
                                    recieptImage,
                                    imagePicker,
                                    selectedFile,
                                    context,
                                    chatPool,
                                    messageController),
                              ],
                            ),
                          ),
                        Container(
                          height: 37,
                          decoration: BoxDecoration(
                            color: MColors.white,
                            border: Border.all(
                              color: MColors.grey5,
                            ),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(Dimens.appRadius),
                                topRight: Radius.circular(Dimens.appRadius)),
                          ),
                          child: const SizedBox(
                            width: double.infinity,
                            height: 53,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      if (hasAttacheFilePressed.value)
                        const SizedBox(height: 50),
                      Container(
                        height: 53,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            hasMicLongPressed.value
                                ? const SizedBox()
                                : Expanded(
                                    child: TextFormField(
                                    controller: messageController,
                                    style: Styles.textBodyBlackStyle,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.all(Dimens.spaceM),
                                      border: InputBorder.none,
                                      hintText: "پیام خود را اینجا بنویسید...",
                                      hintStyle: Styles.textBodyHintStyle,
                                    ),
                                    cursorHeight: 0,
                                    cursorWidth: 0,
                                  )),
                            hasMicLongPressed.value
                                ? Expanded(
                                    child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: Styles.recordSoundGradiant,
                                          boxShadow: [
                                            BoxShadow(
                                              color: MColors.grey4
                                                  .withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: Dimens.spaceM,
                                      ),
                                      Typo(
                                        text:
                                            "${Duration(seconds: timeCounter.value).toString().split('.').first}",
                                        color: MColors.black,
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.chevron_left,
                                        color: MColors.grey3,
                                        size: Dimens.iconSize,
                                      ),
                                      Typo(
                                        text: "بکشید تا لغو شود",
                                        style: Styles.textBodyHintStyle,
                                      ),
                                      const SizedBox(
                                        width: Dimens.spaceM,
                                      ),
                                    ],
                                  ))
                                : const SizedBox(),
                            hasUserTyped.value
                                ? GestureDetector(
                                    onTap: () async {
                                      await sendMessage(chatPool,
                                          messageController, selectedFile);
                                    },
                                    child: Icon(
                                      Icons.send_rounded,
                                      size: Dimens.iconSize,
                                      color: MColors.primaryColor,
                                    ),
                                  )
                                : Row(
                                    children: [
                                      XGestureDetector(
                                        onLongPress: (event) {
                                          hasAttacheFilePressed.value = false;
                                          hasMicLongPressed.value = true;

                                          record(mRecorder,
                                              "${DateTime.now().millisecondsSinceEpoch}.mp4");
                                          // record(_mRecorder, "${DateTime.now().toString()}.mp4");

                                          startTimer(timer, timeCounter);
                                        },
                                        onLongPressEnd: () async {
                                          hasMicLongPressed.value = false;
                                          stopTimer(timer, timeCounter);

                                          String? recordedVoice =
                                              await stopRecorder(
                                                  mRecorder, mplaybackReady);

                                          if (!hasRecordVoiceCanceled.value) {
                                            if (recordedVoice == null ||
                                                recordedVoice.isEmpty) return;

                                            selectedFile.value =
                                                File(recordedVoice ?? "");
                                            await sendMessage(
                                                chatPool,
                                                messageController,
                                                selectedFile);
                                          } else {
                                            if (File(recordedVoice ?? "")
                                                .existsSync()) {
                                              File(recordedVoice ?? "")
                                                  .deleteSync();

                                              hasRecordVoiceCanceled.value =
                                                  false;
                                            }
                                          }
                                        },
                                        onLongPressMove: (event) {
                                          //slide to end
                                          if (event.delta.dx > 0 &&
                                              (event.delta.dy == 0)) {
                                            hasRecordVoiceCanceled.value = true;
                                          }
                                        },
                                        child: Container(
                                          height:
                                              hasMicLongPressed.value ? 53 : 28,
                                          width:
                                              hasMicLongPressed.value ? 53 : 28,
                                          decoration: hasMicLongPressed.value
                                              ? BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient:
                                                      Styles.splashGradiant,
                                                )
                                              : null,
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                hasMicLongPressed.value
                                                    ? 4.0
                                                    : 0.0),
                                            child: Icon(
                                              Iconsax.microphone,
                                              size: hasMicLongPressed.value
                                                  ? Dimens.iconSizeL
                                                  : Dimens.iconSize,
                                              color: hasMicLongPressed.value
                                                  ? MColors.white
                                                  : MColors.grey4,
                                            ),
                                          ),
                                        ),
                                      ),
                                      hasMicLongPressed.value
                                          ? const SizedBox()
                                          : GestureDetector(
                                              onTap: () {
                                                hasAttacheFilePressed.value =
                                                    !hasAttacheFilePressed
                                                        .value;
                                              },
                                              child: const Icon(
                                                Icons.attach_file,
                                                size: Dimens.iconSize,
                                                color: MColors.grey4,
                                              ),
                                            ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSelectFile(
      ValueNotifier<bool> hasAttacheFilePressed,
      ValueNotifier<File?> selectedFile,
      BuildContext context,
      ChatCubit chatPool,
      TextEditingController messageController) {
    return GestureDetector(
      onTap: () async {
        hasAttacheFilePressed.value = !hasAttacheFilePressed.value;

        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result == null) {
          return;
        }

        File file = File(result?.files.single.path ?? "");

        selectedFile.value = file;

        openDialog(
            context,
            ConfirmChatFileDialog(
              file: file,
              onSendFileClicked: () async {
                await sendMessage(chatPool, messageController, selectedFile);
                Navigator.pop(context);
              },
            ));
      },
      child: Container(
        height: 36,
        width: 36,
        padding: const EdgeInsets.all(Dimens.spaceS),
        decoration: BoxDecoration(
            color: MColors.grey7,
            borderRadius: BorderRadius.circular(Dimens.appRadius)),
        child: Icon(
          Iconsax.document,
          color: MColors.primaryColor,
          size: Dimens.iconSize,
        ),
      ),
    );
  }

  Widget buildSelectImageFromGallery(
      ValueNotifier<bool> hasAttacheFilePressed,
      XFile? recieptImage,
      ImagePicker imagePicker,
      ValueNotifier<File?> selectedFile,
      BuildContext context,
      ChatCubit chatPool,
      TextEditingController messageController) {
    return GestureDetector(
      onTap: () async {
        hasAttacheFilePressed.value = !hasAttacheFilePressed.value;

        recieptImage = await imagePicker.pickImage(source: ImageSource.gallery);

        if (recieptImage == null) return;

        print("image name: ${recieptImage?.name ?? ""}");

        selectedFile.value = File(recieptImage?.path ?? "");

        openDialog(
            context,
            ConfirmChatImageDialog(
              receipeImage: recieptImage!,
              onSendClicked: () async {
                await sendMessage(chatPool, messageController, selectedFile);
                Navigator.pop(context);
              },
            ));
      },
      child: Container(
        height: 36,
        width: 36,
        padding: const EdgeInsets.all(Dimens.spaceS),
        decoration: BoxDecoration(
            color: MColors.grey7,
            borderRadius: BorderRadius.circular(Dimens.appRadius)),
        child: Icon(
          Iconsax.gallery,
          color: MColors.primaryColor,
          size: Dimens.iconSize,
        ),
      ),
    );
  }

  Widget buildSelectImageFromCamera(
      ValueNotifier<bool> hasAttacheFilePressed,
      XFile? recieptImage,
      ImagePicker imagePicker,
      ValueNotifier<File?> selectedFile,
      BuildContext context,
      ChatCubit chatPool,
      TextEditingController messageController) {
    return GestureDetector(
      onTap: () async {
        hasAttacheFilePressed.value = !hasAttacheFilePressed.value;

        recieptImage = await imagePicker.pickImage(source: ImageSource.camera);

        if (recieptImage == null) return;
        print("image name: ${recieptImage?.name ?? ""}");

        selectedFile.value = File(recieptImage?.path ?? "");

        openDialog(
            context,
            ConfirmChatImageDialog(
              receipeImage: recieptImage!,
              onSendClicked: () async {
                await sendMessage(chatPool, messageController, selectedFile);

                Navigator.pop(context);
              },
            ));
      },
      child: Container(
        height: 36,
        width: 36,
        padding: const EdgeInsets.all(Dimens.spaceS),
        decoration: BoxDecoration(
            color: MColors.grey7,
            borderRadius: BorderRadius.circular(Dimens.appRadius)),
        child: Icon(
          Iconsax.camera,
          color: MColors.primaryColor,
          size: Dimens.iconSize,
        ),
      ),
    );
  }

  Padding buildChat(ChatCubit chatPool) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.spaceM),
      child: ListView.separated(
          reverse: true,
          controller: chatPool.scrollCntroller,
          itemBuilder: (context, index) {
            return ChatMessageItem(message: chatPool.messages[index]);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: (chatPool.messages[index].isMine &&
                      (chatPool.messages[index + 1].isMine))
                  ? Dimens.spaceS
                  : Dimens.spaceM,
            );
          },
          itemCount: chatPool.messages.length),
    );
  }

  Column buildEmptyChat() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/images/empty_chat_logo.svg"),
        const SizedBox(
          height: Dimens.spaceL,
        ),
        Center(
          child: Typo(
            text: Strings.txtWelcomToChatPage.translate(),
            size: Dimens.textL,
            maxLines: 2,
            color: MColors.black,
          ),
        ),
      ],
    );
  }

  Future<void> sendMessage(
      ChatCubit chatPool,
      TextEditingController messageController,
      ValueNotifier<File?> selectedFile) async {
    TextMessage messgae = TextMessage(
      author: chatPool.chatUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: messageController.text,
      status: Status.sending,
      isMine: true,
    );

    chatPool.client
        ?.sendMessage(
      content: messgae.text,
      echoId: messgae.id,
      attachment: selectedFile.value,
    )
        .catchError((e) {
      logger.e(e);
    });

    chatPool.addMessage(messgae);
    messageController.text = "";
    selectedFile.value = null;
  }

  AppBar buildAppBar(BuildContext context) {
    final chatPool = BlocProvider.of<ChatCubit>(context);
    return AppBar(
      backgroundColor: MColors.white,
      title: Typo(
        text: Strings.txtAppSupport.translate(),
        size: Dimens.textL,
        color: MColors.black,
      ),
      actions: [
        // IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.phone,
        //       color: MColors.primaryColor,
        //     )),
      ],
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spaceM, vertical: Dimens.spaceS),
            child: Row(
              children: [
                BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    return Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: chatPool.client == null
                            ? MColors.danger
                            : MColors.primaryColor2,
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: Dimens.spaceM,
                ),
                Typo(
                  text: getCustomerMobile(),
                  color: MColors.grey3,
                  size: Dimens.textS,
                ),
              ],
            ),
          )),
    );
  }

  getCustomerMobile() {
    return "Gust";
  }

  void startTimer(ValueNotifier<Timer?> timer, ValueNotifier<int> timeCounter) {
    timer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeCounter.value += 1;
    });
  }

  void stopTimer(ValueNotifier<Timer?> timer, ValueNotifier<int> timeCounter) {
    if (timer.value == null) return;
    timer.value?.cancel();
    timeCounter.value = 0;
  }
}
