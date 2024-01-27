// web3_service.txt
import 'package:chatflutter/models/Document.dart';
import 'package:chatflutter/services/web3_connection.dart';
import 'package:web3dart/web3dart.dart';

class DocumentsManagerService {
  late Web3Connection _web3Connection;
  static String contractName = "DocumentsManager";
  late DeployedContract contract;


  DocumentsManagerService(Web3Connection web3Connection) {
    this._web3Connection = web3Connection;

  }

  Future<void> initializeContract() async {
    EthereumAddress contractAddress = await _web3Connection.getContractAddress(contractName);
    this.contract = await _web3Connection.getContract(contractName, contractAddress);
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

  Future<List<Document>> getDocumentsByTemplateName(String templateName) async {
    final contractFunction = contract.function('getDocumentsByTemplateName');
    final result = await _web3Connection.client.call(
      contract: contract,
      function: contractFunction,
      params: [templateName],
    );
    final documents = result[0].toList();
    List<Document> res = [];
    for(int i = 0 ; i < res.length; i++){

    }
    documents.forEach((document)=>{ // Modifier par un DTO dans solidity qui contient directement les champs qui nous interesse en UI
      res.add(Document.fromJson(document))

    });
    return res;
  }

}
