import 'Consts.dart';

class DocumentRequest { // C'est la demande de document par un particulier à un organisme (Particulier ---DocumentRequest--> Organisme)
  String docRequestId; // Modifier par un DTO dans solidity qui contient directement les champs qui nous interesse en UI
  String issuerName;
  String recipientName;
  String templateDocName;
  DocumentTransactionStatus status;

  DocumentRequest({
    required this.docRequestId,
    required this.issuerName,
    required this.recipientName,
    required this.templateDocName,
    required this.status,
  });

  DocumentRequest.fromJson(List<dynamic> json)
      : docRequestId = json[0].toString() as String,
        issuerName = json[2].toString() as String,
        recipientName = json[1].toString() as String,
        templateDocName = json[3].toString() as String ,
        status = statusFromIdentifier(json[4].toString());

}