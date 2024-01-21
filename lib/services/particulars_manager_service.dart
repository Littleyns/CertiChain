// web3_service.txt
import 'package:chatflutter/models/Document.dart';
import 'package:chatflutter/models/DocumentRequest.dart';
import 'package:chatflutter/models/TemplateDocument.dart';
import 'package:chatflutter/services/web3_connection.dart';
import 'package:web3dart/web3dart.dart';

import '../models/Consts.dart';
import '../models/Organisation.dart';

class ParticularsManagerService {
  late Web3Connection _web3Connection;
  static String contractName = "ParticularsManager";
  late DeployedContract contract;


  ParticularsManagerService(Web3Connection web3Connection) {
    this._web3Connection = web3Connection;

  }

  Future<void> initializeContract() async {
    EthereumAddress contractAddress = await _web3Connection.getContractAddress(contractName);
    this.contract = await _web3Connection.getContract(contractName, contractAddress);
  }


  Future<void> createParticular(EthPrivateKey credentials, String particularAddress, String username) async {
    final contractFunction = contract.function('addParticular');
    await _web3Connection.client.sendTransaction(
        credentials,

        Transaction.callContract(
            contract: contract,
            function: contractFunction,
            parameters: [EthereumAddress.fromHex(particularAddress), username]
        ),
        chainId: 1337,
        fetchChainIdFromNetworkId: false
    );
  }


  Future<List<Document>> getAllParticularsDocuments() async {
    final contractFunction = contract.function('getAllParticularDocuments');
    final result = await _web3Connection.client.call(
      contract: contract,
      function: contractFunction,
      params: [],
    );

    final documents = result[0].toList();
    List<Document> res = [];
    documents.forEach((document)=>res.add(Document.fromJson(document)));
    return res;
  }
  Future<List<Document>> getParticularDocuments(String particularAddress) async {
    final contractFunction = contract.function('getParticularDocuments');
    final result = await _web3Connection.client.call(
      contract: contract,
      function: contractFunction,
      params: [EthereumAddress.fromHex(particularAddress)],
    );

    final documents = result[0].toList();
    List<Document> res = [];
    documents.forEach((document)=>res.add(Document.fromJson(document)));
    return res;
  }

  Future<void> addFavouriteOrg(EthPrivateKey credentials, String orgAddress) async {
    final contractFunction = contract.function('addFavouriteOrg');
    await _web3Connection.client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contractFunction,
        parameters: [EthereumAddress.fromHex(orgAddress)],
      ),
      chainId: 1337,
      fetchChainIdFromNetworkId: false,
    );
  }


}
