import 'dart:convert';

import 'package:ezstate/ez.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black.withOpacity(0.002)),
  );

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

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  final ezCounter = "counter";

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color.fromARGB(255, 118, 150, 63),
                child: EZ(
                  ezCounter,
                  initialValue: 0,
                  persist: true,
                  builder: (v) => FittedBox(child: Text("$v")),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color.fromARGB(255, 255, 187, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CupertinoButton(
                      color: Colors.black,
                      onPressed: () => EZ.get<int>(ezCounter).value++,
                      child: const Text("Click me",
                          style: TextStyle(color: Colors.white)),
                    ),
                    CupertinoButton(
                      color: Colors.black,
                      onPressed: () => EZ.get<int>(ezCounter).value = 0,
                      child: const Text("Reset",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
