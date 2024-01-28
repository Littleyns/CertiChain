import 'package:chatflutter/screens/common/blockchain_screen.dart';
import 'package:chatflutter/screens/organisation/create_screen.dart';
import 'package:chatflutter/screens/particular/home_screen.dart';
import 'package:chatflutter/screens/main_organisations.dart';
import 'package:chatflutter/screens/main_particulars.dart';
import 'package:chatflutter/screens/particular/search_screen.dart';
import 'package:chatflutter/services/organisations_manager_service.dart';
import 'package:chatflutter/services/user_session.dart';
import 'package:chatflutter/services/web3_connection.dart';
import 'package:chatflutter/widgets/particular/custom_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import 'models/AuthenticatedUser.dart';
import 'models/Organisation.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  // when implement authentication replace this line with async function that fetch private and publickey

  // This is a particular auth
  //UserSession.loginUser(new AuthenticatedUser(publicKey: '0x0df08E74FFd70cd5D4C28D5bA6261755040E69d1', privateKey: '0x3537081c99dff4618e1f3de8382912a1d7ccf651ade0e015b45b79cf25808384', type: UserType.Particular));

  // This is an organisation auth
  UserSession.loginUser(new AuthenticatedUser(publicKey: '0xA16842b28FF96Ec695008996F0D85BE705A2c4Dd', privateKey: '0xf0906fd865d515fed0f4563175bfc5da0eb44cce630fac63a8ede30816d2e6ed', type: UserType.Organisation));

  runApp(MyApp(currentUser: UserSession.currentUser));
}

class MyApp extends StatelessWidget {
  final AuthenticatedUser currentUser;
  const MyApp({super.key, required this.currentUser});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.light(),
        useMaterial3: true,
      ),
      home:  currentUser.type == UserType.Particular ? MainParticulars(title: 'Flutter Demo test Home Page') : MainOrganisations(title: 'Flutter Demo test Home Page'),
    );
  }
}
