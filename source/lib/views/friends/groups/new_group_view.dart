import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:miniGames/logic/friends/friends_groups_logic.dart';
import 'package:miniGames/views/custom_elements/modified_scaffold.dart';
import 'package:miniGames/views/custom_elements/input_decoration.dart';

/// UI to create a new group of friends.
class NewGroupView extends StatelessWidget {
  final _nameForm = GlobalKey<FormState>();
  final FriendsGroupsLogic _friendsGroupsLogic;

  NewGroupView(this._friendsGroupsLogic);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _friendsGroupsLogic,
        child: Consumer<FriendsGroupsLogic>(
            builder: (context, friendsGroupsLogic, _) {
          return ModifiedScaffold.modifiedScaffold(
              "New group",
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_friendsGroupsLogic.messageCreateGroup,
                        style: _friendsGroupsLogic.messageCreateGroupStyle),
                    Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Form(
                            key: _nameForm,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    controller:
                                        _friendsGroupsLogic.nameFormController,
                                    decoration:
                                        InputDecorationBuilder.formDecoration(
                                            Icon(Icons.group), "Name"),
                                  ),
                                  SizedBox(height: 10),
                                  FlatButton(
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onPressed: () =>
                                        _friendsGroupsLogic.createsNewGroup(),
                                    child: Text("Create"),
                                  )
                                ]))),
                  ]));
        }));
  }
}
