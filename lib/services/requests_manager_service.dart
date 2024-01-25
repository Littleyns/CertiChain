// web3_service.txt
import 'package:chatflutter/models/Document.dart';
import 'package:chatflutter/models/DocumentRequest.dart';
import 'package:chatflutter/models/TemplateDocument.dart';
import 'package:chatflutter/services/web3_connection.dart';
import 'package:web3dart/web3dart.dart';

import '../models/Consts.dart';
import '../models/Organisation.dart';

class RequestsManagerService {
  late Web3Connection _web3Connection;
  static String contractName = "RequestsManager";
  late DeployedContract contract;


  RequestsManagerService(Web3Connection web3Connection) {
    this._web3Connection = web3Connection;

  }

  Future<void> initializeContract() async {
    EthereumAddress contractAddress = await _web3Connection.getContractAddress(contractName);
    this.contract = await _web3Connection.getContract(contractName, contractAddress);
  }



  Future<void> requestDocument(
      Credentials credentials, String orgAddress, String templateDocId) async {
    final contractFunction = contract.function('requestDocument');
    await _web3Connection.client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contractFunction,
        parameters: [
          EthereumAddress.fromHex(orgAddress),
          BigInt.parse(templateDocId),
        ],
      ),
        chainId: 1337,
        fetchChainIdFromNetworkId: false
    );
  }

  Future<void> acceptGrantedDocument(
      Credentials credentials, String grantRequestId) async {
    final contractFunction = contract.function('acceptGrantedDocument');
    await _web3Connection.client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contractFunction,
        parameters: [BigInt.parse(grantRequestId)],
      ),
        chainId: 1337,
        fetchChainIdFromNetworkId: false
    );
  }

  Future<void> rejectDocumentRequest(
      Credentials credentials, String docRequestId) async {
    final contractFunction = contract.function('rejectDocumentRequest');
    await _web3Connection.client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contractFunction,
        parameters: [BigInt.parse(docRequestId)],
      ),
        chainId: 1337,
        fetchChainIdFromNetworkId: false
    );
  }

  Future<void> requestDocumentGrant(
      Credentials credentials, String particularAddress, String templateDocId, String description, BigInt expirationDate) async {
    final contractFunction = contract.function('requestDocumentGrant');
    await _web3Connection.client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contractFunction,
        parameters: [
          EthereumAddress.fromHex(particularAddress),
          BigInt.parse(templateDocId),
          description,
          expirationDate
        ],
      ),
        chainId: 1337,
        fetchChainIdFromNetworkId: false
    );
  }

  Future<void> acceptDocumentRequest(
      Credentials credentials, String docRequestId, String description, BigInt expirationDate) async {
    final contractFunction = contract.function('acceptDocumentRequest');
    await _web3Connection.client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contractFunction,
        parameters: [
          BigInt.parse(docRequestId),
          description,
          expirationDate

        ],
      ),
        chainId: 1337,
        fetchChainIdFromNetworkId: false
    );
  }

  Future<void> rejectDocumentGrant(
      Credentials credentials, String grantRequestId) async {
    final contractFunction = contract.function('rejectDocumentGrant');
    await _web3Connection.client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contractFunction,
        parameters: [BigInt.parse(grantRequestId)],
      ),
        chainId: 1337,
        fetchChainIdFromNetworkId: false
    );
  }

}
