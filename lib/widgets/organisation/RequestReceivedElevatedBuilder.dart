import 'package:flutter/material.dart';

import 'package:chatflutter/models/Consts.dart';
import 'package:chatflutter/models/DocumentRequest.dart';

import '../../models/AuthenticatedUser.dart';
import '../../services/requests_manager_service.dart';
import '../../services/user_session.dart';




class RequestReceivedElevatedBuilder {
  static List<Widget> buildButtons({
    required List<DocumentRequest> documentRequests,
    required Function(DocumentRequest) onPressed,
    required Function(AuthenticatedUser user, DocumentRequest dreq, RequestsManagerService reqService) onAccepted,
    required Function(AuthenticatedUser user, DocumentRequest dreq, RequestsManagerService reqService) onRefused,
    required RequestsManagerService reqService

  }) {
    List<Widget> buttons = [];

    for (int i = 0; i < documentRequests.length; i++) {
      String issuerName = documentRequests[i].issuerName;
      String templateDocName = documentRequests[i].templateDocName;
      String status = documentRequests[i].status.name;

      ElevatedButton button = ElevatedButton(
        onPressed: () => onPressed(documentRequests[i]),
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
              issuerName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              templateDocName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 8.0),
            documentRequests[i].status==DocumentTransactionStatus.Pending?Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () => onAccepted(UserSession.currentUser, documentRequests[i],reqService),style:ElevatedButton.styleFrom(
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
                ElevatedButton(onPressed: () => onRefused(UserSession.currentUser, documentRequests[i],reqService),style:ElevatedButton.styleFrom(
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
