// web3_service.txt
import 'dart:convert';
import 'dart:html';

import 'package:flutter/services.dart';
import 'package:http/src/client.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';


class Web3Connection {
  late String _rpcUrl;
  late String _wsUrl;
  late String _privatekey;
  late EthPrivateKey _creds;

  EthPrivateKey get creds => _creds;
  late Web3Client client;

  Web3Connection(String rpcUrl, String wsUrl, String pkey) {
    this._rpcUrl = rpcUrl;
    this._wsUrl = wsUrl;
    this._privatekey = pkey;
    init();
  }

  Future<void> init() async {
    client = Web3Client(
      _rpcUrl,
      Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
    await getCredentials();
  }


  Future<ContractAbi> getABI(String _contractName) async {
    String abiFile = await rootBundle.loadString('../build/contracts/'+_contractName+'.json');
    var jsonABI = jsonDecode(abiFile);
    ContractAbi _abiCode = ContractAbi.fromJson(jsonEncode(jsonABI['abi']), _contractName);
    return _abiCode;

  }
  Future<EthereumAddress> getContractAddress(String _contractName) async {
    String abiFile = await rootBundle.loadString('../build/contracts/'+_contractName+'.json');
    var jsonABI = jsonDecode(abiFile);
    EthereumAddress ContractAddress = EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
    return ContractAddress;

  }


  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privatekey);
  }

  Future<DeployedContract> getContract(String _contractName, EthereumAddress _contractAddress) async {
    ContractAbi _abiCode = await getABI(_contractName);
    return DeployedContract(_abiCode, _contractAddress);
  }

}
