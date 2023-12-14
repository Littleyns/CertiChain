
import 'package:chatflutter/services/web3_connection.dart';
import 'package:chatflutter/services/web3_service.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:web3dart/credentials.dart';
void main() async {
  // Right before you would be doing any loading
  WidgetsFlutterBinding.ensureInitialized();

  Web3Connection web3Conn = new Web3Connection("http://127.0.0.1:7545", "ws://127.0.0.1:7545", "0x85289cd8817f6df013284fb557cfdb5b9feada4f9556be58594c2c9ac2afe970");
  Web3Service web3Service = new Web3Service(web3Conn);
  EthereumAddress contractAddr = await web3Conn.getContractAddress("DocumentsManager");

  await web3Service.initializeContract("DocumentsManager", contractAddr);

  // Création d'organisations
  String adressePubliqueOrganisation = "0xdA6Bb12d7C02565df8C4dC1C86A881aa2597d2F0";
  String adressePriveeOrganisation = "0xa69668c0758e18e4a1ed504b27bb57e6fb4d4c8a39a64ef92b0747e0f0ec2751";
  web3Service.createOrganisation(web3Conn.creds, adressePubliqueOrganisation, "Organisation 1");
  String orgName = await web3Service.getOrganisationName(adressePubliqueOrganisation);
  print(orgName+" Created");


  // création d'un particulier
  String adressePubliqueParticulier = "0xDd0719e04aba937706AceB33AB7124a5C82015dC";
  String adressePriveeParticulier = "0x25f07dffc01add33580be7cfd168de14a2ed6204f3b76fe4b590180f30d28804";
  web3Service.createParticular(EthPrivateKey.fromHex(adressePriveeParticulier), adressePubliqueParticulier, "toto");


  //Création de templates de document
  web3Service.createTemplateDocument(EthPrivateKey.fromHex(adressePriveeOrganisation),adressePubliqueOrganisation,"Diplome d'ingénieur");
  web3Service.createTemplateDocument(EthPrivateKey.fromHex(adressePriveeOrganisation),adressePubliqueOrganisation,"Master spécialisé en big data");


  // Récupération des documents de l'organisation
  List<dynamic> templateDocuments = await web3Service.getOrgTemplateDocuments(adressePubliqueOrganisation);
  print(templateDocuments);


  print("Ended...");
}