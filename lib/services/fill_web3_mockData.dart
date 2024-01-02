
import 'package:chatflutter/services/web3_connection.dart';
import 'package:chatflutter/services/web3_service.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:web3dart/credentials.dart';

import '../models/DocumentRequest.dart';
import '../models/TemplateDocument.dart';
import '../models/Document.dart';
void main() async {
  // Right before you would be doing any loading
  WidgetsFlutterBinding.ensureInitialized();
  String addressPriveeServer = "0x85289cd8817f6df013284fb557cfdb5b9feada4f9556be58594c2c9ac2afe970";
  Web3Connection web3Conn = new Web3Connection("http://127.0.0.1:7545", "ws://127.0.0.1:7545", addressPriveeServer);
  Web3Service web3Service = new Web3Service(web3Conn);
  EthereumAddress contractAddr = await web3Conn.getContractAddress("DocumentsManager");

  await web3Service.initializeContract("DocumentsManager", contractAddr);

  // Création d'organisations
  String adressePubliqueOrganisation = "0xdA6Bb12d7C02565df8C4dC1C86A881aa2597d2F0";
  String adressePriveeOrganisation = "0xa69668c0758e18e4a1ed504b27bb57e6fb4d4c8a39a64ef92b0747e0f0ec2751";
  await web3Service.createOrganisation(web3Conn.creds, adressePubliqueOrganisation, "Organisation 1");
  String orgName = await web3Service.getOrganisationName(adressePubliqueOrganisation);
  print(orgName+" Created");


  // création d'un particulier
  String adressePubliqueParticulier = "0xDd0719e04aba937706AceB33AB7124a5C82015dC";
  String adressePriveeParticulier = "0x25f07dffc01add33580be7cfd168de14a2ed6204f3b76fe4b590180f30d28804";
  await web3Service.createParticular(EthPrivateKey.fromHex(adressePriveeParticulier), adressePubliqueParticulier, "toto");

  // création d'un autre particulier
  String adressePubliqueParticulier2 = "0xce65F53487f121D7054b5b2feF7e691B3564036a";
  String adressePriveeParticulier2 = "0x950ac78ce1746778732c25f71a7b272acd465167b75f583f7d09f110010ce642";
  await web3Service.createParticular(EthPrivateKey.fromHex(adressePriveeParticulier2), adressePubliqueParticulier2, "tata");

  //Création de templates de document
  await web3Service.createTemplateDocument(EthPrivateKey.fromHex(adressePriveeOrganisation),adressePubliqueOrganisation,"Diplome d'ingénieur");
  await web3Service.createTemplateDocument(EthPrivateKey.fromHex(adressePriveeOrganisation),adressePubliqueOrganisation,"Master spécialisé en big data");


  // Récupération des documents de l'organisation
  List<TemplateDocument> templateDocuments = await web3Service.getOrgTemplateDocuments(adressePubliqueOrganisation);
  print(templateDocuments);
  TemplateDocument diplomeInge = templateDocuments[0];
  TemplateDocument masterSpecialise= templateDocuments[1];
  //Demande d'un document par toto à un organisme
  await web3Service.requestDocument(EthPrivateKey.fromHex(adressePriveeParticulier),adressePubliqueOrganisation,diplomeInge.id);
  print("Document requested from toto to 3iL");

  //Demande d'un document par toto à un organisme
  await web3Service.requestDocument(EthPrivateKey.fromHex(adressePriveeParticulier),adressePubliqueOrganisation,masterSpecialise.id);
  print("Document requested from toto to 3iL");

  //Demande d'un document par particulier2 à un organisme
  await web3Service.requestDocument(EthPrivateKey.fromHex(adressePriveeParticulier2),adressePubliqueOrganisation,masterSpecialise.id);
  print("Document requested from tata to 3iL");

  //Demande d'un document par particulier2 à un organisme
  await web3Service.requestDocument(EthPrivateKey.fromHex(adressePriveeParticulier2),adressePubliqueOrganisation,diplomeInge.id);
  print("Document requested from tata to 3iL");

  // Récuperer les requetes d'un organisme
  List<DocumentRequest> docRequests = await web3Service.getOrgRequestsReceived(EthPrivateKey.fromHex(adressePriveeOrganisation),adressePubliqueOrganisation);

  // acceptation tout les requetes par 3iL
  for(int i = 0; i< docRequests.length/2;i++){
    await web3Service.acceptDocumentRequest(EthPrivateKey.fromHex(adressePriveeOrganisation),docRequests[i].docRequestId); // changer l'id, récuperer toutes les requetes d'un utilisateur
    print("Document accepted from organisation");
  }

  //Récupération des documents de l'utilisateur
  List<Document> documentsParticulier =await web3Service.getParticularDocuments(adressePubliqueParticulier);
  print(documentsParticulier);

  print("Ended...");
}