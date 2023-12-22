import 'Consts.dart';

class DocumentRequest { // C'est la demande de document par un particulier à un organisme (Particulier ---DocumentRequest--> Organisme)
  int docRequestId;
  String issuer;
  String recipient;
  int templateDocId;
  DocumentTransactionStatus status;

  DocumentRequest({
    required this.docRequestId,
    required this.issuer,
    required this.recipient,
    required this.templateDocId,
    required this.status,
  });
}