import 'package:flutter/material.dart';
import 'package:chatflutter/models/Document.dart';

import 'package:chatflutter/models/TemplateDocument.dart';
class TDocsElevatedBuilder {
  static List<Widget> buildButtons({
    required List<TemplateDocument> tDocs,
    required Function(TemplateDocument) onPressed,
  }) {
    List<Widget> buttons = [];

    for (int i = 0; i < tDocs.length; i++) {
      String templateDocName = tDocs[i].name;
      //String description = documents[i].description;
      //String owner = documents[i].ParticularOwner;

      ElevatedButton button = ElevatedButton(
        onPressed: () => onPressed(tDocs[i]),
        style: ElevatedButton.styleFrom(
          primary: i % 2 == 0 ? Colors.black : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              templateDocName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),

          ],
        ),
      );

      buttons.add(button);
    }

    return buttons;
  }
}