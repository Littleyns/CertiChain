import 'package:flutter/material.dart';
import '../models/Document.dart';
import 'Consts.dart';
import 'DocumentRequest.dart';



class ElevatedButtonBuilder3 {
  static List<Widget> buildButtons({
    required List<DocumentRequest> documentRequests,
    required Function(DocumentRequest) onPressed,
  }) {
    List<Widget> buttons = [];

    for (int i = 0; i < documentRequests.length; i++) {
      String issuerName = documentRequests[i].issuerName;
      String templateDocName = documentRequests[i].templateDocName;
      String status = _getStatusString(documentRequests[i].status);

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
                fontSize: 12.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              status,
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

  static String _getStatusString(DocumentTransactionStatus status) {
    switch (status) {
      case DocumentTransactionStatus.Pending:
        return 'Pending';
      case DocumentTransactionStatus.Approved:
        return 'Approved';
      case DocumentTransactionStatus.Rejected:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }
}
