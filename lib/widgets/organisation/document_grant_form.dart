import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import '../../models/AuthenticatedUser.dart';
import '../../models/DocumentRequest.dart';
import '../../models/GrantRequest.dart';
import '../../models/Particular.dart';
import '../../models/TemplateDocument.dart';
import '../../services/organisations_manager_service.dart';
import '../../services/particulars_manager_service.dart';
import '../../services/requests_manager_service.dart';
import '../../services/user_session.dart';
import '../../services/web3_connection.dart';
import '../common/ParticularsAutoComplete.dart';


void _showPopupDocGranted(BuildContext context, String templateDocName, String recipientName) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Demande d'attribution de document effectuée"),
        content: Row(children: [Text('Vous avez attribué le document :'),Text('${templateDocName}',style: const TextStyle(
            fontSize: 15.0, fontWeight: FontWeight.bold)),
          Text(" à "),
          Text('${recipientName}',style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold))
        ],),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Code à exécuter lorsque le bouton est pressé
              Navigator.of(context).pop(); // Pour fermer le popup
            },
            child: Text('Fermer'),
          ),
        ],
      );
    },
  );
}

class DocumentGrantForm extends StatefulWidget {
  final DocumentRequest? docRequest;
  DocumentGrantForm({Key? key,  this.docRequest = null}) : super(key: key);

  @override
  _MyDocumentGrantFormState createState() => _MyDocumentGrantFormState();
}

class _MyDocumentGrantFormState extends State<DocumentGrantForm> {
  final TextEditingController publicKeyController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  late TemplateDocument selectedTemplateDoc;
  late Particular selectedParticular;

  late List<TemplateDocument> templateDocuments;
  late AuthenticatedUser user;
  late OrganisationsManagerService organisationService; // Ajout de la variable pour la connexion Web3
  late RequestsManagerService requestsService;
  late ParticularsManagerService particularsService;
  final inputDecoration = (labelText) => InputDecoration(
    contentPadding: const EdgeInsets.all(20),
    labelText: labelText,
    focusColor: Colors.black,
    fillColor: Colors.black,
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 3, color: Color(0xff6c5ce7)),
      borderRadius: BorderRadius.circular(15),
    ),
  );

  bool noExpirationDate = false; // Nouvelle variable pour la case à cocher

  @override
  void initState() {
    super.initState();
    try {
      user = UserSession.currentUser;
      // Utilisez currentUser ici
    } catch (e) {
      // Gérez l'erreur si aucun utilisateur n'est connecté
    }
    if(widget.docRequest != null){
      selectedParticular = new Particular(particularAddress: widget.docRequest!.issuerAddress ?? "", username: widget.docRequest!.issuerName, favouriteOrgs: []);
      selectedTemplateDoc = new TemplateDocument(id: "-1", name: widget.docRequest?.templateDocName??"");
    }


    _initializationAsync();
  }

  Future<void> _initializationAsync() async {
    Web3Connection web3Conn = new Web3Connection("http://${dotenv.get('GANACHE_HOST')}:${dotenv.get('GANACHE_PORT')}",
        "ws://${dotenv.get('GANACHE_HOST')}:${dotenv.get('GANACHE_PORT')}", dotenv.get('PKEY_SERVER'));

    organisationService = new OrganisationsManagerService(web3Conn);
    requestsService = new RequestsManagerService(web3Conn);
    particularsService = new ParticularsManagerService(web3Conn);
    await organisationService.initializeContract();
    await requestsService.initializeContract();
    await particularsService.initializeContract();
    List<TemplateDocument> orgTemplateDocuments =
    await organisationService.getOrgTemplateDocuments(user.publicKey);
    setState(() {
      templateDocuments = orgTemplateDocuments;
      selectedTemplateDoc = selectedTemplateDoc;
    });
  }

  void selectParticular(Particular sp){
    setState(() {
      selectedParticular = sp;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulaire d'attribution de document"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.docRequest==null
            ?ParticularAutocomplete(particularsService: particularsService,inputDecoration: inputDecoration("User public key"),onSelected: selectParticular)
            :TextFormField(
              readOnly: true,
              maxLines: 2,
              controller:TextEditingController(text:'${widget.docRequest?.issuerAddress} (${widget.docRequest?.issuerName})' ?? "placeholder"),
              decoration: InputDecoration(
                enabled: false,
                contentPadding: const EdgeInsets.all(20),
                labelText: "Particular",

                focusColor: Colors.black,
                fillColor: Colors.black,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Color(0xff6c5ce7)),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            SizedBox(height: 16.0),
            widget.docRequest==null
                ?Autocomplete<TemplateDocument>(
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextFormField(
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.black),
                  controller: textEditingController,
                  focusNode: focusNode,
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                  decoration: inputDecoration("Document Template"),
                );
              },
              optionsBuilder: (TextEditingValue textEditingValue) {
                // Filtrer les documents en fonction de ce que l'utilisateur a tapé.
                Iterable<TemplateDocument> filtered = templateDocuments.where((TemplateDocument doc) =>
                    doc.name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                print(filtered);
                return filtered;
              },
              onSelected: (TemplateDocument selectedTDoc) {
                // Gérez la sélection de l'utilisateur ici.
                setState(() {
                  selectedTemplateDoc = selectedTDoc;
                });
              },
              displayStringForOption: (TemplateDocument option) => option.name,
            )
            :TextFormField(
              readOnly: true,
              maxLines: 2,
              controller:TextEditingController(text:'${widget.docRequest?.templateDocName}' ?? "placeholder"),
              decoration: InputDecoration(
                enabled: false,
                contentPadding: const EdgeInsets.all(20),
                labelText: "Document Template",

                focusColor: Colors.black,
                fillColor: Colors.black,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Color(0xff6c5ce7)),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            SizedBox(height: 16.0),
            TextFormField(
              controller: descriptionController,
              maxLines: 2,
              decoration: inputDecoration("Description"),
            ),
            SizedBox(height: 16.0),

            Row(
              children: [
                Checkbox(
                  value: noExpirationDate,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        noExpirationDate = value;
                      });
                    }
                  },

                ),
                Text("No expiration date"),
              ],
            ),

            if (!noExpirationDate) // Affiche le champ de sélection de date sauf si "No expiration date" est coché
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
              onPressed: () async {
                // Vous pouvez récupérer les valeurs avec les contrôleurs ici
                print('User Public Key: ${selectedParticular.particularAddress}');
                print('Template Document Name: ${selectedTemplateDoc.name}');
                print('Description: ${descriptionController.text}');
                print('Expiration Date: $selectedDate');
                var expirationDate;
                if(noExpirationDate || selectedDate == null) {
                  expirationDate = BigInt.from(-1);
                } else {
                  expirationDate = BigInt.from(selectedDate?.millisecondsSinceEpoch as num);
                }
                if(widget.docRequest == null){
                  await requestsService.requestDocumentGrant(EthPrivateKey.fromHex(user.privateKey), selectedParticular.particularAddress, selectedTemplateDoc.id, descriptionController.text, expirationDate);
                } else {
                  await requestsService.acceptDocumentRequest(EthPrivateKey.fromHex(user.privateKey), widget.docRequest?.docRequestId ?? "0", descriptionController.text, expirationDate);
                  Navigator.of(context).pop(true);
                }

                _showPopupDocGranted(context,selectedTemplateDoc.name, selectedParticular.username);
              },
              child: Text(widget.docRequest==null ?'Grant !': 'Accept Document Request!'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    if (noExpirationDate) {
      // Si "No expiration date" est coché, ne rien faire
      return;
    }

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
