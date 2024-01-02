import 'TemplateDocument.dart';

class Document {
  String docId;
  TemplateDocument templateDoc;
  String description;
  String organisationAddress;
  String particularAddress;

  Document({
    required this.docId,
    required this.templateDoc,
    required this.description,
    required this.organisationAddress,
    required this.particularAddress,
  });



  @override
  String toString() {
    return "Template Doc: ${templateDoc} | ID: ${docId} | description: ${description} | owner: ${particularAddress} | org transmitter ${organisationAddress}" ;
  }
}
