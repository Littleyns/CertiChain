import 'Consts.dart';

class GrantRequest { // C'est l'attribution d'un document à un particulier par un organisme (Organisme ---GrantRequest--> Particulier)
  int grantRequestId;
  String issuer;
  String recipient;
  int docId;
  DocumentTransactionStatus status;

  GrantRequest({
    required this.grantRequestId,
    required this.issuer,
    required this.recipient,
    required this.docId,
    required this.status,
  });
}