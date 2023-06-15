/*
* Easy State Manager for Flutter - [0.0.2]
*
* Copyright (C) by skullchap - https://github.com/skullchap
*
* This code is licensed under the MIT license (MIT) (http://opensource.org/licenses/MIT)
*/

import 'package:flutter/widgets.dart';

/// The `EzValue` class is a generic class that stores a value, based on a key.
///
/// It also allows for seamless integration with persisted data sources, making it a useful tool for state management in Flutter applications.
class EzValue<T> {
  /// The  `EzValue`  class constructor creates an instance of the class with a key ( `k` ), a value ( `v` ), and an optional boolean value for persistence ( `persist` ).
  /// #### Parameters:
  /// -  `k` : A key of type  `String`  used to identify the  `EzValue`  object.
  /// -  `v` : An initial value of type  `T`  for the  `EzValue`  object.
  /// -  `persist` : An optional boolean value that indicates whether the value should be persisted.
  /// #### Example:
  /// `final myValue = EzValue('myKey', 42, persist: true);`
  ///
  /// This creates an  `EzValue`  object with a key of  `'myKey'` , an initial value of  `42` , and persistence enabled.
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

  /// A static function that takes a `String key` and a generic `value` of type `T` and stores the value persistently.
  static void Function<T>(String k, T value)? setPersist;

  /// A static function that takes a `String key` and returns the corresponding value if it exists in the persistent storage
  static T? Function<T>(String k)? getPersist;

  /// A getter that returns the current value of the `EzValue` object.
  T get value => notifier.value;

  /// A setter that sets the current value of the  EzValue  object.
  ///
  /// If  persist  is true and  setPersist  is not null, it also stores the value persistently.
  set value(T newValue) {
    notifier.value = newValue;
    if (persist && setPersist != null) {
      setPersist!(k, newValue);
    }
  }
}

/// The `EZ` class is a state management tool that provides a simple way to manage and
/// share state across your Flutter application. It creates an instance of the class with a key (`k`),
/// an optional initial value (`initialValue`), an optional boolean value for persistence (`persist`),
/// and a builder function that takes the current value of the `EZ` object and returns a `Widget`.
///
/// To use the `EZ` class, you can set an initial value for a key using the `set` method
/// and create an `EZ` object with the same key. The `EZ` object will automatically update
/// its value whenever the `set` method is called with the same key. The `builder` function is called whenever the value of the `EZ` object changes, allowing you to update your UI accordingly.
///
/// The `EZ` class is built on top of the `EzValue` class, which provides the underlying state management logic.
/// The `EZ` class simplifies the process of creating and managing `EzValue` objects by providing a convenient builder
/// function and a shared registry of `EzValue` objects.
///
/// #### Parameters:
/// - `k`: A `String` value that represents the key used to identify the `EZ` object.
/// - `initialValue`: An optional generic value of type `T` that represents the initial value of the `EZ` object.
/// - `persist`: An optional boolean value that indicates whether the value should be persisted.
/// - `builder`: A required `Widget Function(T value)` that takes the current value of the `EZ` object and returns a `Widget`.
///
/// #### Methods:
/// - `get`: A static method that takes a `String` key and returns the corresponding `EzValue` object if it exists.
/// - `set`: A static method that takes a `String` key and an initial value of type `T`
/// and sets the object at `key` or creates a new `EzValue` object if it doesn't already exist
///
/// #### Example:
/// `EZ.set<String>('myKey', initialValue: 'initialValue', persist: true); `
///
/// `EZ<String>('myKey', builder: (value) => Text(value)); `
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

  /// A static method that takes a  String  key and returns the corresponding `EzValue` object if it exists.
  static EzValue<T> get<T>(key) {
    var value = _eznotifiers[key];
    if (value != null) return value as EzValue<T>;
    throw Exception("EzValue `$value` isn't set yet");
  }

  /// A static method that takes a `String` key and an value of type `T`
  /// and sets the object at `key` or creates a new `EzValue` object if it doesn't already exist
  static set<T>(String k, {required T initialValue, bool persist = false}) {
    var ezNotifier = _eznotifiers[k];
    if (ezNotifier == null) {
      _eznotifiers[k] = EzValue<T>(k, initialValue, persist: persist);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) {
      set(k, initialValue: initialValue!, persist: persist);
    }
    return ValueListenableBuilder(
        valueListenable: get(k).notifier,
        builder: (context, dynamic v, __) {
          return builder(v);
        });
  }
}
