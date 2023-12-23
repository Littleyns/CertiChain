import 'Consts.dart';

class GrantRequest { // C'est l'attribution d'un document à un particulier par un organisme (Organisme ---GrantRequest--> Particulier)
  String grantRequestId;
  String issuer;
  String recipient;
  String docId;
  DocumentTransactionStatus status;

  GrantRequest({
    required this.grantRequestId,
    required this.issuer,
    required this.recipient,
    required this.docId,
    required this.status,
  });
}