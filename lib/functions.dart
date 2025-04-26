import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void rmvFocus() => FocusManager.instance.primaryFocus?.unfocus();

Future<void> copyClipboard(String data) async {
  try {
    Clipboard.setData(ClipboardData(text: data));

    
  } catch (e, s) {
    log("#CopyClipboardError", error: e, stackTrace: s);
  }
}
