import 'package:flutter/material.dart';

class DocumentGrantForm extends StatefulWidget {
  @override
  _MyDocumentGrantFormState createState() => _MyDocumentGrantFormState();
}

class _MyDocumentGrantFormState extends State<DocumentGrantForm> {
  final TextEditingController publicKeyController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController templateNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulaire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: publicKeyController,
              decoration: InputDecoration(labelText: 'User Public Key'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: templateNameController,
              decoration: InputDecoration(labelText: 'Template Document Name'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Expiration Date:',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    selectedDate != null
                        ? "${selectedDate!.toLocal()}".split(' ')[0]
                        : 'Sélectionner une date',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Vous pouvez récupérer les valeurs avec les contrôleurs ici
                print('User Public Key: ${publicKeyController.text}');
                print('Username: ${usernameController.text}');
                print('Template Document Name: ${templateNameController.text}');
                print('Description: ${descriptionController.text}');
                print('Expiration Date: $selectedDate');
              },
              child: Text('Soumettre'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
