
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
  String addressPriveeServer = "0xea40a2a81abad9f80697273a06b0120771f2dcdf9dd97e130a87c88a35f6ec66";
  Web3Connection web3Conn = new Web3Connection("http://127.0.0.1:7545", "ws://127.0.0.1:7545", addressPriveeServer);
  Web3Service web3Service = new Web3Service(web3Conn);
  EthereumAddress contractAddr = await web3Conn.getContractAddress("DocumentsManager");

  await web3Service.initializeContract("DocumentsManager", contractAddr);

  // Création d'organisations
  String adressePubliqueOrganisation = "0x47a25e9481E001b1bDBeaB869561C9707F2f922B";
  String adressePriveeOrganisation = "0xb11a6d990e8ec3189045db3125f51ddf76a48d4ec1d076284246ca86a722eef6";
  await web3Service.createOrganisation(web3Conn.creds, adressePubliqueOrganisation, "Organisation 1");
  String orgName = await web3Service.getOrganisationName(adressePubliqueOrganisation);
  print(orgName+" Created");


  // création d'un particulier
  String adressePubliqueParticulier = "0x1C83F5bF35A80Bc1Cc02c85c668832a4615a32bd";
  String adressePriveeParticulier = "0x43d27c28420212fd8172b28ca82b6e33b26d6ebb3967a0cc7128b58844be7bff";
  await web3Service.createParticular(EthPrivateKey.fromHex(adressePriveeParticulier), adressePubliqueParticulier, "toto");

  // création d'un autre particulier
  String adressePubliqueParticulier2 = "0x42164E78e298E98500437666A3a84D885FdEf020";
  String adressePriveeParticulier2 = "0x84ce07483033938c9f96ed7ac3efc8add8778beaed03fb5d5e1692aa84de2cdf";
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
  for(int i = 0; i< docRequests.length;i++){
    await web3Service.acceptDocumentRequest(EthPrivateKey.fromHex(adressePriveeOrganisation),docRequests[i].docRequestId); // changer l'id, récuperer toutes les requetes d'un utilisateur
    print("Document accepted from organisation");
  }

  //Récupération des documents de l'utilisateur
  List<Document> documentsParticulier =await web3Service.getParticularDocuments(adressePubliqueParticulier);
  print(documentsParticulier);

  print("Ended...");
}