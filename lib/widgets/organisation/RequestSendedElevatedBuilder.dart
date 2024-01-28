import 'package:chatflutter/models/Consts.dart';
import 'package:chatflutter/models/Document.dart';
import 'package:flutter/material.dart';
import 'package:chatflutter/models/AuthenticatedUser.dart';
import 'package:chatflutter/models/GrantRequest.dart';
import 'package:chatflutter/services/requests_manager_service.dart';
import 'package:chatflutter/services/user_session.dart';

import '../../models/DocumentRequest.dart';


class RequestSendedElevatedBuilder {
  static List<Widget> buildButtons({
    required List<GrantRequest> grantRequests,
    required Function(GrantRequest) onPressed

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
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "Template Doc: ${request.doc.templateDocName}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "Description: ${request.doc.description}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "Date d'expiration: ${request.doc.getExpirationDateTime()}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "Status: ${request.status.name}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
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
