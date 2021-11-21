import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/logic/settings_logic.dart';
import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/views/custom_elements/input_decoration.dart';

/// UI of the settings.
class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConnectionLogic _cntLogic = Provider.of<ConnectionLogic>(context);
    if (_cntLogic.isGuest) {
      return Center(
          child: Column(children: <Widget>[
        SizedBox(height: 20),
        Text("Settings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text("You are not logged in!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            ]))
      ]));
    }
    return ChangeNotifierProvider(
        create: (context) => SettingsLogic(_cntLogic),
        child: Consumer<SettingsLogic>(builder: (context, _settingsLogic, _) {
          return Center(
              child: Column(children: <Widget>[
            SizedBox(height: 20),
            Text("Settings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(_settingsLogic.statusMessage,
                            style: _settingsLogic.messageStyle),
                        SizedBox(height: 20),
                        Divider(
                            color: Colors.black,
                            height: 10,
                            thickness: 1,
                            indent: MediaQuery.of(context).size.width / 3,
                            endIndent: MediaQuery.of(context).size.width / 3),
                        SizedBox(height: 20),
                        Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Form(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                  TextFormField(
                                      obscureText: _settingsLogic.hidePassword,
                                      controller:
                                          _settingsLogic.newPasswordController,
                                      decoration:
                                          InputDecorationBuilder.formDecoration(
                                              Icon(Icons.lock),
                                              "New password")),
                                  SizedBox(height: 15),
                                  CheckboxListTile(
                                      title: Text("Hide password"),
                                      value: _settingsLogic.hidePassword,
                                      onChanged: (bool value) {
                                        _settingsLogic.swapHidePassword(value);
                                      }),
                                  SizedBox(height: 15),
                                  FlatButton(
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      onPressed: () =>
                                          _settingsLogic.updatesPassword(),
                                      child: Text("UPDATE PASSWORD"))
                                ]))),
                        SizedBox(height: 20),
                        Divider(
                            color: Colors.black,
                            height: 10,
                            thickness: 1,
                            indent: MediaQuery.of(context).size.width / 3,
                            endIndent: MediaQuery.of(context).size.width / 3),
                        SizedBox(height: 20),
                        Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Form(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                  TextFormField(
                                      controller:
                                          _settingsLogic.newEmailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration:
                                          InputDecorationBuilder.formDecoration(
                                              Icon(Icons.lock), "New email")),
                                  SizedBox(height: 15),
                                  FlatButton(
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      onPressed: () =>
                                          _settingsLogic.updatesEmail(),
                                      child: Text("UPDATE EMAIL"))
                                ])))
                      ])
                ],
              ),
            )
          ]));
        }));
  }
}
