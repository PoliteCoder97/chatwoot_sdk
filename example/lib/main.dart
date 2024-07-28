import 'package:example/chat/presentation/pages/chat_support_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat/presentation/manager/chat_cubit.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => ChatCubit(),
      )
    ],
    child: MaterialApp(
      home: ChatSupportPage("test"),
    ),
  ));
}
