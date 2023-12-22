// web3_service.dart
import 'package:chatflutter/services/web3_connection.dart';
import 'package:web3dart/web3dart.dart';

class Web3Service {
  late Web3Connection _web3Connection;
  late DeployedContract contract;


  Web3Service(Web3Connection web3Connection) {
    this._web3Connection = web3Connection;

  }

  Future<void> initializeContract(String contractName, EthereumAddress contractAddress) async {
    this.contract = await _web3Connection.getContract(contractName, contractAddress);
  }


  Future<void> createOrganisation(EthPrivateKey credentials, String orgAddress, String name) async {
    final contractFunction = contract.function('addOrganisation');
    await _web3Connection.client.sendTransaction(
      credentials,

      Transaction.callContract(
        contract: contract,
        function: contractFunction,
        parameters: [EthereumAddress.fromHex(orgAddress), name]
      ),
      chainId: 1337,
      fetchChainIdFromNetworkId: false
    );
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

  Future<String> getOrganisationName(String orgAddress) async{
    final contractFunction = contract.function('organisations');
    var resp = await _web3Connection.client.call(contract: contract, function: contractFunction, params: [EthereumAddress.fromHex(orgAddress)]);
    return resp[1];
  }

  Future<void> createTemplateDocument(Credentials credentials, String orgAddress, String name) async {
    final contractFunction = contract.function('createTemplateDocument');
    await _web3Connection.client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contractFunction,
        parameters: [EthereumAddress.fromHex(orgAddress), name],
      ),
        chainId: 1337,
        fetchChainIdFromNetworkId: false
    );
  }

  Future<List<dynamic>> getOrgTemplateDocuments(String orgAddress) async {
    final contractFunction = contract.function('getOrgTemplateDocuments');
    final result = await _web3Connection.client.call(
      contract: contract,
      function: contractFunction,
      params: [EthereumAddress.fromHex(orgAddress)],
    );

    final templateDocuments = result[0].toList();
    return templateDocuments.map((document) {
      return {
        'id': document[0],
        'name': document[1],
      };
    }).toList();
  }
  Future<List<dynamic>> getParticularDocuments(String particularAddress) async {
    final contractFunction = contract.function('getParticularDocuments');
    final result = await _web3Connection.client.call(
      contract: contract,
      function: contractFunction,
      params: [EthereumAddress.fromHex(particularAddress)],
    );

    final documents = result[0].toList();
    return documents.map((document) {
      return {
        'docId': document[0],
        'templateDoc': document[1],
        'description': document[2],
      };
    }).toList();
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
      Credentials credentials, String particularAddress, String templateDocId) async {
    final contractFunction = contract.function('requestDocumentGrant');
    await _web3Connection.client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contractFunction,
        parameters: [
          EthereumAddress.fromHex(particularAddress),
          BigInt.parse(templateDocId),
        ],
      ),
        chainId: 1337,
        fetchChainIdFromNetworkId: false
    );
  }

  Future<void> acceptDocumentRequest(
      Credentials credentials, String docRequestId) async {
    final contractFunction = contract.function('acceptDocumentRequest');
    await _web3Connection.client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contractFunction,
        parameters: [
          BigInt.parse(docRequestId),
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
