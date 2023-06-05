# ezstate
### ~65 loc state manager for flutter

Wrap your widget with EZ builder and set unique key to it:

```dart

final ezCounter = "counter"; // key

EZ(
  ezCounter,
  initialValue: 0, // can be any type of any value
  builder: (value) => Text("$value"),
)
```
To set or get widget's state from anywhere:
```dart
EZ.get(ezCounter).value++
```

EZ builder also has additional ```persist``` parameter. By setting `EzValue.setPersist` and `EzValue.getPersist` handlers you can control your state's persistency.

Example with SharedPreferences:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var prefs = await SharedPreferences.getInstance();

  void sp<T>(String k, T v) {
    prefs.setString(k, jsonEncode(v));
  }

  T? gp<T>(String k) {
    var v = prefs.getString(k);
    if (v != null) return jsonDecode(v);
    return null;
  }

  EzValue.setPersist = sp;
  EzValue.getPersist = gp;

  runApp(const App());
}

// ...

EZ(
  ezCounter,
  initialValue: 0,
  persist: true,  // state will be preserved after app restart
  builder: (value) => Text("$value"),
)
  
// ... 
```

To watch state change at multiple widgets, skip initial value:
```dart
EZ(
  ezCounter,
  builder: (value) => SomeWidget(value),
)
```

### Add to project at pubspec.yaml under dependencies (maybe one day at pub.dev):
```yaml
dependencies:
  flutter:
    sdk: flutter
    
  ezstate:
    git:
      url: https://github.com/skullchap/ezstate.git
      ref: master
```

# Changes
[0.0.70] - Added ability to watch state change at multiple widgets
# License

MIT
