import 'package:chatflutter/models/Consts.dart';
import 'package:flutter/material.dart';
import 'package:chatflutter/models/AuthenticatedUser.dart';
import 'package:chatflutter/models/GrantRequest.dart';
import 'package:chatflutter/services/requests_manager_service.dart';
import 'package:chatflutter/services/user_session.dart';


class ElevatedButtonBuilder4 {
  static List<Widget> buildButtons({
    required List<GrantRequest> grantRequests,
    required Function(GrantRequest) onPressed, required Function(AuthenticatedUser user, GrantRequest dreq, RequestsManagerService reqService) onAccepted,required Function(AuthenticatedUser user, GrantRequest dreq, RequestsManagerService reqService) onRefused, required RequestsManagerService reqService
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
            SizedBox(height: 8.0),
            request.status==DocumentTransactionStatus.Pending?Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () => onAccepted(UserSession.currentUser, request,reqService),style:ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ), child: Text("Accepter",style:TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ))),
                SizedBox(width: 8.0),
                ElevatedButton(onPressed: () => onRefused(UserSession.currentUser, request,reqService),style:ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),child: Text("Refuser",style:TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ))),
            ],):SizedBox(height: 8.0)
          ],
        ),
      );

      buttons.add(button);
    }

    return buttons;
  }
}
