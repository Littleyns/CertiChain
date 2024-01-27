import 'package:flutter/material.dart';
import 'GrantRequest.dart';


class ElevatedButtonBuilder4 {
  static List<Widget> buildButtons({
    required List<GrantRequest> grantRequests,
    required Function(GrantRequest) onPressed,
  }) {
    List<Widget> buttons = [];

    for (int i = 0; i < grantRequests.length; i++) {
      GrantRequest request = grantRequests[i];

      ElevatedButton button = ElevatedButton(
        onPressed: () => onPressed(request),
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
              "Issuer: ${request.issuerName}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "Recipient: ${request.recipientName}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "Template Doc: ${request.doc.templateDocName}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
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
