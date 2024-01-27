// web3_service.txt
import 'package:chatflutter/models/Document.dart';
import 'package:chatflutter/models/DocumentRequest.dart';
import 'package:chatflutter/models/TemplateDocument.dart';
import 'package:chatflutter/services/web3_connection.dart';
import 'package:web3dart/web3dart.dart';

import '../models/Organisation.dart';

class OrganisationsManagerService {
  late Web3Connection _web3Connection;
  static String contractName = "OrganisationsManager";
  late DeployedContract contract;


  OrganisationsManagerService(Web3Connection web3Connection) {
    this._web3Connection = web3Connection;

  }

  Future<void> initializeContract() async {
    EthereumAddress contractAddress = await _web3Connection.getContractAddress(contractName);
    this.contract = await _web3Connection.getContract(contractName, contractAddress);
  }


  Future<void> createOrganisation(EthPrivateKey credentials, String orgAddress, Domain d,String name) async {
    final contractFunction = contract.function('addOrganisation');
    await _web3Connection.client.sendTransaction(
      credentials,

      Transaction.callContract(
        contract: contract,
        function: contractFunction,
        parameters: [EthereumAddress.fromHex(orgAddress),BigInt.parse(d.index.toString()), name]
      ),
      chainId: 1337,
      fetchChainIdFromNetworkId: false
    );
  }

  Future<List<DocumentRequest>> getOrgRequestsReceived(EthPrivateKey credentials, String orgAddress) async {
    final contractFunction = contract.function('getOrgRequestsReceived');
    final result = await _web3Connection.client.call(
      contract: contract,
      function: contractFunction,
      sender: credentials.address,
      params: [EthereumAddress.fromHex(orgAddress)],
    );

    final documentRequests = result[0].toList();
    List<DocumentRequest> res = [];
    documentRequests.forEach((document)=>res.add(DocumentRequest.fromJson(document)));
    return res;
  }

  Future<String> getOrganisationName(String orgAddress) async{
    final contractFunction = contract.function('organisations');
    var resp = await _web3Connection.client.call(contract: contract, function: contractFunction, params: [EthereumAddress.fromHex(orgAddress)]);
    return resp[1];
  }

  Future<List<TemplateDocument>> getOrgTemplateDocuments(String orgAddress) async {
    final contractFunction = contract.function('getOrgTemplateDocuments');
    final result = await _web3Connection.client.call(
      contract: contract,
      function: contractFunction,
      params: [EthereumAddress.fromHex(orgAddress)],
    );

    final templateDocuments = result[0].toList();
    List<TemplateDocument> res = [];
    templateDocuments.forEach((document)=>res.add(TemplateDocument(id: document[0].toString(), name: document[1])));
    return res;
  }

    Future<List<Document>> getOrgDocuments(String orgAddress) async {
      final contractFunction = contract.function('getOrgDocuments');
      final result = await _web3Connection.client.call(
        contract: contract,
        function: contractFunction,
        params: [EthereumAddress.fromHex(orgAddress)],
      );

    final documents = result[0].toList();
    List<Document> res = [];
    documents.forEach((document)=>res.add(Document.fromJson(document)));
    return res;
  }

  Future<List<Organisation>> getAllOrganisations(EthPrivateKey particularCredentials) async {
    final contractFunction = contract.function('getAllOrganisations');
    final result = await _web3Connection.client.call(
      contract: contract,
      function: contractFunction,
      sender: particularCredentials.address,
      params: [],
    );

    final organisations = result[0].toList();
    List<Organisation> res = [];
    organisations.forEach((org)=>res.add(Organisation.fromJson(org)));
    return res;
  }


}
