import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/views/custom_elements/input_decoration.dart';
import 'package:miniGames/logic/register_logic.dart';

/// UI of the register page.
class RegisterView extends StatelessWidget {
  final _registerForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RegisterLogic(),
        child: Consumer<RegisterLogic>(builder: (context, rgtLogic, _) {
          return Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(title: Text("Mini games")),
              body: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Text("${rgtLogic.welcomeMessage}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${rgtLogic.message}", style: rgtLogic.messageStyle),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Form(
                          key: _registerForm,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                    controller: rgtLogic.emailFormController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration:
                                        InputDecorationBuilder.formDecoration(
                                            Icon(Icons.mail_outline), "Email")),
                                TextFormField(
                                    controller: rgtLogic.usrFormController,
                                    decoration:
                                        InputDecorationBuilder.formDecoration(
                                            Icon(Icons.person), "Username")),
                                TextFormField(
                                    obscureText: true,
                                    controller: rgtLogic.pswdFormController,
                                    decoration:
                                        InputDecorationBuilder.formDecoration(
                                            Icon(Icons.lock), "Password")),
                                SizedBox(height: 20),
                                FlatButton(
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onPressed: () => rgtLogic.checkForm(),
                                    child: Text("Register"))
                              ])),
                    )
                  ])));
        }));
  }
}
