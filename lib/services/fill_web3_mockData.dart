
import 'package:chatflutter/services/organisations_manager_service.dart';
import 'package:chatflutter/services/particulars_manager_service.dart';
import 'package:chatflutter/services/requests_manager_service.dart';
import 'package:chatflutter/services/web3_connection.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import '../models/DocumentRequest.dart';
import '../models/GrantRequest.dart';
import '../models/Organisation.dart';
import '../models/TemplateDocument.dart';
import '../models/Document.dart';
import 'documents_manager_service.dart';
void main() async {
  // Right before you would be doing any loading
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  String addressPriveeServer = "0x69b39aa2fb86c7172d77d4b87b459ed7643c1e4b052536561e08d7d25592b373";
  Web3Connection web3Conn = new Web3Connection("http://${dotenv.get('GANACHE_HOST')}:${dotenv.get('GANACHE_PORT')}", "ws://${dotenv.get('GANACHE_HOST')}:${dotenv.get('GANACHE_PORT')}", addressPriveeServer);

  OrganisationsManagerService organisationsService = new OrganisationsManagerService(web3Conn);
  RequestsManagerService requestsService = new RequestsManagerService(web3Conn);
  ParticularsManagerService particularsService = new ParticularsManagerService(web3Conn);
  DocumentsManagerService documentsService = new DocumentsManagerService(web3Conn);

  await organisationsService.initializeContract();
  await requestsService.initializeContract();
  await particularsService.initializeContract();
  await documentsService.initializeContract();

  // Création d'organisations
  String adressePubliqueOrganisation = "0xA16842b28FF96Ec695008996F0D85BE705A2c4Dd";
  String adressePriveeOrganisation = "0xf0906fd865d515fed0f4563175bfc5da0eb44cce630fac63a8ede30816d2e6ed";
  await organisationsService.createOrganisation(web3Conn.creds, adressePubliqueOrganisation,Domain.Education, "3iL");
  String orgName = await organisationsService.getOrganisationName(adressePubliqueOrganisation);
  print(orgName+" Created");


  // création d'un particulier
  String adressePubliqueParticulier = "0x0df08E74FFd70cd5D4C28D5bA6261755040E69d1";
  String adressePriveeParticulier = "0x3537081c99dff4618e1f3de8382912a1d7ccf651ade0e015b45b79cf25808384";
  await particularsService.createParticular(EthPrivateKey.fromHex(adressePriveeParticulier), adressePubliqueParticulier, "toto");

  // création d'un autre particulier
  String adressePubliqueParticulier2 = "0x7e2d0b3fCdFEbd1469A779aaebb62D87d9f10fF3";
  String adressePriveeParticulier2 = "0x9d39fd4825cd5782ad312221d7fbba40588e6f595c1f92e4f70c4e9a8ab44015";
  await particularsService.createParticular(EthPrivateKey.fromHex(adressePriveeParticulier2), adressePubliqueParticulier2, "tata");


  //Création de templates de document
  await documentsService.createTemplateDocument(EthPrivateKey.fromHex(adressePriveeOrganisation),adressePubliqueOrganisation,"Diplome d'ingénieur");
  await documentsService.createTemplateDocument(EthPrivateKey.fromHex(adressePriveeOrganisation),adressePubliqueOrganisation,"Master spécialisé en big data");
  await documentsService.createTemplateDocument(EthPrivateKey.fromHex(adressePriveeOrganisation),adressePubliqueOrganisation,"Master spécialisé cybsecurité");


  // Récupération des documents de l'organisation
  List<TemplateDocument> templateDocuments = await organisationsService.getOrgTemplateDocuments(adressePubliqueOrganisation);
  print(templateDocuments);
  TemplateDocument diplomeInge = templateDocuments[0];
  TemplateDocument masterSpecialise= templateDocuments[1];
  TemplateDocument masterCyber= templateDocuments[2];
  //Demande d'un document par toto à un organisme
  await requestsService.requestDocument(EthPrivateKey.fromHex(adressePriveeParticulier),adressePubliqueOrganisation,diplomeInge.id);
  print("Document requested from toto to 3iL");

  //Demande d'un document par toto à un organisme
  await requestsService.requestDocument(EthPrivateKey.fromHex(adressePriveeParticulier),adressePubliqueOrganisation,masterSpecialise.id);
  print("Document requested from toto to 3iL");

  //Demande d'un document par particulier2 à un organisme
  await requestsService.requestDocument(EthPrivateKey.fromHex(adressePriveeParticulier2),adressePubliqueOrganisation,masterSpecialise.id);
  print("Document requested from tata to 3iL");

  //Demande d'un document par particulier2 à un organisme
  await requestsService.requestDocument(EthPrivateKey.fromHex(adressePriveeParticulier2),adressePubliqueOrganisation,diplomeInge.id);
  print("Document requested from tata to 3iL");

  // Récuperer les requetes d'un organisme
  List<DocumentRequest> docRequests = await organisationsService.getOrgRequestsReceived(EthPrivateKey.fromHex(adressePriveeOrganisation),adressePubliqueOrganisation);

  // acceptation tout les requetes par 3iL
  for(int i = 0; i< docRequests.length;i++){
    await requestsService.acceptDocumentRequest(EthPrivateKey.fromHex(adressePriveeOrganisation),docRequests[i].docRequestId, "well deserved doc", BigInt.from(-1)); // changer l'id, récuperer toutes les requetes d'un utilisateur
    print("Document accepted from organisation");
  }

  // 3il offre un master specialisé en cyber securité à toto
  requestsService.requestDocumentGrant(EthPrivateKey.fromHex(adressePriveeOrganisation),adressePubliqueParticulier,masterCyber.id,"bien merité certifié owasp",BigInt.from(-1));

  //Récupération des documents de l'utilisateur
  List<Document> documentsParticulier =await particularsService.getParticularDocuments(adressePubliqueParticulier);
  print(documentsParticulier);

  // toto add 3il to favourite orgs
  await particularsService.addFavouriteOrg(EthPrivateKey.fromHex(adressePriveeParticulier), adressePubliqueOrganisation);
  List<Organisation> totoFavouriteOrgs = await particularsService.getFavouriteOrgs(EthPrivateKey.fromHex(adressePriveeParticulier));
  print("Toto Favourite orgs:");
  print(totoFavouriteOrgs);

  // get toto's requests
  List<DocumentRequest> docRequestsSended = await particularsService.getParticularDocRequestsSended(EthPrivateKey.fromHex(adressePriveeParticulier));
  print(docRequestsSended);

  // get toto's granted docs
  List<GrantRequest> docRequestsReceived = await particularsService.getParticularDocGrantRequestsReceived(EthPrivateKey.fromHex(adressePriveeParticulier));
  print(docRequestsReceived);

  print("Ended...");
}