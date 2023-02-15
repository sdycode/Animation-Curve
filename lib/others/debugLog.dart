import 'dart:developer';

import 'package:flutter/foundation.dart';

debugLog(String s) {
  if (kDebugMode) {
    log(s);
  }
}
