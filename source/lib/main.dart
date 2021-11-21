import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/views/connection_view.dart';

Future main() async {
  // required for firestore
  WidgetsFlutterBinding.ensureInitialized();
  // force portrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Initialization
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "error",
                color: Colors.white,
                home: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Error while initializing FlutterFire",
                              style: TextStyle(color: Colors.red))
                        ])));
          }

          // Completed
          if (snapshot.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider(
                create: (_) => ConnectionLogic(),
                child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: "miniGames",
                    theme: ThemeData(
                        visualDensity: VisualDensity.adaptivePlatformDensity),
                    home: ConnectionView()));
          }

          // On going
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "loading",
              home: Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(value: null)
                      ])));
        });
  }
}
