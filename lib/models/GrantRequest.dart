import 'package:chatflutter/models/Document.dart';

import 'Consts.dart';
import 'Organisation.dart';
import 'Particular.dart';

class GrantRequest { // C'est l'attribution d'un document à un particulier par un organisme (Organisme ---GrantRequest--> Particulier)
  String grantRequestId; // Modifier par un DTO dans solidity qui contient directement les champs qui nous interesse en UI
  String issuerName;
  String recipientName;
  Document doc;
  DocumentTransactionStatus status;

  GrantRequest({
    required this.grantRequestId,
    required this.issuerName,
    required this.recipientName,
    required this.doc,
    required this.status,
  });

  GrantRequest.fromJson(List<dynamic> json)
      : grantRequestId = json[0].toString() as String,
        issuerName = json[1].toString() as String,
        recipientName = json[2].toString() as String,
        doc = Document.fromJson(json[3]),
        status = statusFromIdentifier(json[4].toString().toString());
}