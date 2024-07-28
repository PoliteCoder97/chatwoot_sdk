import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LifecycleArgs {
  final String currentRoute;
  String? nextRoute;
  Map<String, dynamic>? arguments;

  LifecycleArgs({required this.currentRoute, this.nextRoute, this.arguments});

  @override
  String toString() {
    return json.encode(toMap());
  }

  static LifecycleArgs? fromString(String jsonString) {
    try {
      return LifecycleArgs.fromMap(json.decode(jsonString));
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "currentRoute": currentRoute,
      "nextRoute": nextRoute,
      "arguments": json.encode(arguments)
    };
  }

  factory LifecycleArgs.fromMap(Map<String, dynamic> map) {
    return LifecycleArgs(
      currentRoute: map['currentRoute'],
      nextRoute: map['nextRoute'],
      arguments: json.decode(map['arguments'] ?? "{}") as Map<String, dynamic>,
    );
  }

}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback inActiveCallBack;
  final AsyncCallback pauseCallBack;
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  LifecycleEventHandler({
    required this.inActiveCallBack,
    required this.pauseCallBack,
    required this.resumeCallBack,
    required this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
      case AppLifecycleState.inactive:
        await inActiveCallBack();
        break;
      case AppLifecycleState.paused:
        await pauseCallBack();
        break;
      case AppLifecycleState.detached:
        await suspendingCallBack();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
