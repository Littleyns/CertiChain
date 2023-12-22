import 'TemplateDocument.dart';

class Document {
  int docId;
  TemplateDocument templateDoc;
  String description;

  Document({
    required this.docId,
    required this.templateDoc,
    required this.description,
  });
}
