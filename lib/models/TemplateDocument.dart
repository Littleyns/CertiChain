class TemplateDocument { // Modifier par un DTO dans solidity qui contient directement les champs qui nous interesse en UI
  String id;
  String name;

  TemplateDocument({required this.id, required this.name});

  TemplateDocument.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString() as String,
        name = json['name'] as String;

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
  };

  @override
  String toString() {
    return "Name: ${name} | ID: ${id}" ;
  }
}