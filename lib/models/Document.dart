import 'Organisation.dart';
import 'Particular.dart';
import 'TemplateDocument.dart';

class Document {
  String docId;
  String templateDocName;
  String description;
  String organisationEmitter;
  String ParticularOwner;

  Document({ // Modifier par un DTO dans solidity qui contient directement les champs qui nous interesse en UI
    required this.docId,
    required this.templateDocName,
    required this.description,
    required this.organisationEmitter,
    required this.ParticularOwner,
  });


  Document.fromJson(List<dynamic> json)
      : docId = json[0].toString() as String,
        templateDocName = json[1].toString() as String,
        description = json[2].toString() as String,
        organisationEmitter = json[3].toString()as String ,
        ParticularOwner = json[4].toString() as String;



  @override
  String toString() {
    return "Template Doc: ${templateDocName} | ID: ${docId} | description: ${description} | owner: ${ParticularOwner} | org transmitter ${organisationEmitter}" ;
  }


}
