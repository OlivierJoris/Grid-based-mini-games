import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/logic/homepage_logic.dart';

/// UI of the home page.
class HomePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cntProvider = Provider.of<ConnectionLogic>(context);
    return ChangeNotifierProvider(
        create: (context) => HomePageLogic(cntProvider),
        child: Consumer<HomePageLogic>(builder: (context, hpLogic, _) {
          return Scaffold(
              // prevent keyboard from hiding TextFields
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              appBar: AppBar(
                  title: Text("Mini games"),
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                                    title: Text("Disconnect ?"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("No")),
                                      TextButton(
                                          onPressed: () {
                                            cntProvider.disconnect();
                                            Navigator.of(context)
                                                .pop(); // removes AlertDialog
                                            Navigator.of(context)
                                                .pop(); // removes HomePageView
                                          },
                                          child: Text("Yes",
                                              style:
                                                  TextStyle(color: Colors.red)))
                                    ]));
                      })),
              body: hpLogic.currentView,
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.black,
                  backgroundColor: Colors.blue,
                  currentIndex: hpLogic.barCurrentIndex,
                  onTap: (index) => hpLogic.changeView = index,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: "Games"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.leaderboard), label: "Rankings"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.group), label: "Friends"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings), label: "Settings")
                  ]));
        }));
  }
}
