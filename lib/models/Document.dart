import 'TemplateDocument.dart';

class Document {
  String docId;
  TemplateDocument templateDoc;
  String description;

  Document({
    required this.docId,
    required this.templateDoc,
    required this.description,
  });

  Document.fromJson(Map<String, dynamic> json)
      : docId = json['docId'] as String,
        templateDoc = TemplateDocument.fromJson(json['templateDoc']),
        description = json['description'] as String;

  Map<String, dynamic> toJson() => {
    'description': description,
    'templateDoc': templateDoc.toJson(),
    'docId': docId,
  };

  @override
  String toString() {
    return "Template Doc: ${templateDoc} | ID: ${docId} | description: ${description}" ;
  }
}
