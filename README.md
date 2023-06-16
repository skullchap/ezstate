# ezstate
#### ~70 loc state manager for flutter

ezstate is a simple and lightweight state management tool for Flutter applications. It provides an easy way to manage and share state across your application without the need for complex setup or boilerplate code. 

## Features 
 
ezstate provides the following features: 
 
- Easy to use:  ezstate simplifies the process of creating and managing state by providing a convenient builder function and a shared registry of state objects. 
- Lightweight:  ezstate is a lightweight package that doesn't add unnecessary complexity or overhead to your application. 
- Persistence:  ezstate provides an optional persistence feature that allows you to save state across app sessions. 

## Usage

Wrap your widget with EZ builder and set unique key to it:

```dart
import 'package:ez_flutter/ez_flutter.dart';

final ezCounter = "counter"; // key

EZ(
  ezCounter,
  initialValue: 0, // can be any type of any value
  disposable: true, // by default, it's false, but if's true, the key and value will be dropped when the widget is disposed
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
  disposable: false, // disposable should never be enabled, while persist is enable and viceversa
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
[0.0.3] - Added `delete` and `has` methods to EZ and added `disposable` flag to constructor

[0.0.2] - Added ability to watch state change at multiple widgets
# License

MIT
