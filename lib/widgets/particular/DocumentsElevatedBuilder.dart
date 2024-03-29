import 'package:flutter/material.dart';
import 'package:chatflutter/models/Document.dart';
class DocumentsElevatedBuilder {
  static List<Widget> buildButtons({
    required List<Document> documents,
    required Function(Document) onPressed,
  }) {
    List<Widget> buttons = [];

    for (int i = 0; i < documents.length; i++) {
      String templateDocName = documents[i].templateDocName;
      //String description = documents[i].description;
      //String owner = documents[i].ParticularOwner;

      ElevatedButton button = ElevatedButton(
        onPressed: () => onPressed(documents[i]),
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
            /*SizedBox(height: 8.0),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              owner,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),*/
          ],
        ),
      );

      buttons.add(button);
    }

    return buttons;
  }
}