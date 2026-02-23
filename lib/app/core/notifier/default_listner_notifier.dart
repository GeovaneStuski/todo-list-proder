// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_todo_list/app/core/notifier/default_change_notifier.dart';
import 'package:flutter_todo_list/app/core/ui/messages.dart';

class DefaultListnerNotifier {
  DefaultChangeNotifier defaultNotifier;

  DefaultListnerNotifier({required this.defaultNotifier});

  void listener({
    required BuildContext context,
    required SuccessVoidCallback successCallback,
    ErrorVoidCallback? errorCallback,
  }) {
    defaultNotifier.addListener(() {
      if (defaultNotifier.isLoading) {
        Loader.show(context);
      } else {
        Loader.hide();
      }

      if (defaultNotifier.hasError) {
        if (errorCallback != null) {
          errorCallback(defaultNotifier, this);
        }

        Messages.of(context).showError(defaultNotifier.error ?? "Erro interno");
      }

      if (defaultNotifier.isSuccess) {
        successCallback(defaultNotifier, this);
      }
    });
  }

  void dispose() {
    defaultNotifier.removeListener(() {});
  }
}

typedef SuccessVoidCallback =
    Function(
      DefaultChangeNotifier notifier,
      DefaultListnerNotifier listenerInstance,
    );

typedef ErrorVoidCallback =
    Function(
      DefaultChangeNotifier notifier,
      DefaultListnerNotifier listenerInstance,
    );
