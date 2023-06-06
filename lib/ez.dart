/*
* Easy State Manager for Flutter - [0.0.2]
*
* Copyright (C) by skullchap - https://github.com/skullchap
*
* This code is licensed under the MIT license (MIT) (http://opensource.org/licenses/MIT)
*/

import 'dart:developer';
import 'package:flutter/widgets.dart';

class EzValue<T> {
  EzValue(this.k, this.v, {this.persist = false}) {
    notifier = ValueNotifier<T>(v);
    if (persist && getPersist != null) {
      var val = getPersist!(k);
      if (val != null) notifier.value = val;
    }
    if (!persist && setPersist != null) {
      setPersist!(k, null);
    }
  }
  late ValueNotifier<T> notifier;

  final String k;
  final T v;
  final bool persist;
  static void Function<T>(String k, T value)? setPersist;
  static T? Function<T>(String k)? getPersist;

  T get value => notifier.value;

  set value(T newValue) {
    notifier.value = newValue;
    if (persist && setPersist != null) {
      setPersist!(k, newValue);
    }
  }
}

class EZ<T> extends StatelessWidget {
  const EZ(
    this.k, {
    Key? key,
    this.initialValue,
    this.persist = false,
    required this.builder,
  }) : super(key: key);

  final String k;
  final T? initialValue;
  final bool persist;
  final Widget Function(T value) builder;

  static final Map<String, EzValue> _eznotifiers = {};
  static EzValue get(key) {
    var value = _eznotifiers[key];
    if (value != null) return value;
    log("ez: key not found");
    return EzValue("", null);
  }

  static set<T>(String k, {required T initialValue, bool persist = false}) {
    var ezNotifier = _eznotifiers[k];
    if (ezNotifier == null) {
      _eznotifiers[k] = EzValue<T>(k, initialValue, persist: persist);
    }
//     else {
//       log("ez: $k already exist");
//     }
  }

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) {
      set(k, initialValue: initialValue, persist: persist);
    }
    return ValueListenableBuilder(
        valueListenable: get(k).notifier,
        builder: (context, dynamic v, __) {
          return builder(v);
        });
  }
}
