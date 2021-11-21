import 'package:flutter/material.dart';

/// Custom InputDecoration for form's field.
abstract class InputDecorationBuilder {
  /// Generates InputDecoration for TextFormField given an icon [icn] and a text [txt].
  static InputDecoration formDecoration(Widget icn, String txt) =>
      InputDecoration(
          icon: icn, labelText: txt, contentPadding: EdgeInsets.all(5));
}
