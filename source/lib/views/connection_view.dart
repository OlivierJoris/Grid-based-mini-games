import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/logic/connection_logic.dart';
import 'package:miniGames/views/home_page_view.dart';
import 'package:miniGames/views/custom_elements/input_decoration.dart';
import 'package:miniGames/views/register_view.dart';

/// UI of the connection page.
class ConnectionView extends StatelessWidget {
  final _connectionForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionLogic>(builder: (context, cntLogic, _) {
      return Scaffold(
          backgroundColor: Colors.white,
          // avoid UI overflow when keyboard is displayed
          resizeToAvoidBottomInset: true,
          appBar: AppBar(title: Text("Mini games")),
          body: Center(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                SizedBox(height: 20),
                Image.asset('assets/controller.png', width: 100),
                SizedBox(height: 20),
                Text("${cntLogic.message}", style: cntLogic.messageStyle),
                SizedBox(height: 10),
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Form(
                        key: _connectionForm,
                        child: Column(children: <Widget>[
                          TextFormField(
                              controller: cntLogic.usrFormController,
                              enableSuggestions: false,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecorationBuilder.formDecoration(
                                  Icon(Icons.person), "Email")),
                          SizedBox(height: 10),
                          TextFormField(
                              obscureText: true,
                              enableSuggestions: false,
                              controller: cntLogic.pswdFormController,
                              decoration: InputDecorationBuilder.formDecoration(
                                  Icon(Icons.lock), "Password")),
                          SizedBox(height: 20),
                          FlatButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              onPressed: () => cntLogic.checkForm(context),
                              child: Text("Connection"))
                        ]))),
                SizedBox(height: 16),
                FlatButton(
                    child: Text("Register"),
                    color: Colors.blue,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterView()));
                    }),
                SizedBox(height: 16),
                FlatButton(
                    child: Text("Play as guest"),
                    color: Colors.green,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () {
                      // Switches to HomePageWiew
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomePageView()));
                    })
              ]))));
    });
  }
}
