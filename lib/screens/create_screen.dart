import 'package:flutter/material.dart';
import 'package:web3dart/credentials.dart';

import '../models/AuthenticatedUser.dart';

class CreateScreen extends StatelessWidget {
  final AuthenticatedUser authenticatedUser;
  const CreateScreen({Key? key, required this.authenticatedUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Authenticated user ${EthereumAddress.fromHex(authenticatedUser.privateKey)}"),);
  }
}
