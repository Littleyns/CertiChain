import 'package:chatflutter/models/Document.dart';

import 'Consts.dart';
import 'Organisation.dart';
import 'Particular.dart';

class GrantRequest { // C'est l'attribution d'un document à un particulier par un organisme (Organisme ---GrantRequest--> Particulier)
  String grantRequestId; // Modifier par un DTO dans solidity qui contient directement les champs qui nous interesse en UI
  Organisation issuer;
  Particular recipient;
  Document doc;
  DocumentTransactionStatus status;

  GrantRequest({
    required this.grantRequestId,
    required this.issuer,
    required this.recipient,
    required this.doc,
    required this.status,
  });
}