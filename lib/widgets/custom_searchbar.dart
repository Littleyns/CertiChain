import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:chatflutter/widgets/ElevatedButtonBuilder.dart';
import 'package:chatflutter/services/web3_connection.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import '../models/AuthenticatedUser.dart';
import '../models/DocumentRequest.dart';
import '../services/documents_manager_service.dart';
import '../widgets/ElevatedButtonBuilder2.dart';
import '../widgets/ElevatedButtonBuilder3.dart';
import '../widgets/ElevatedButtonBuilder4.dart';
import '../models/GrantRequest.dart';
import '../models/Organisation.dart';
import '../models/TemplateDocument.dart';
import '../models/Document.dart';
import '../services/organisations_manager_service.dart';
import '../services/particulars_manager_service.dart';
import '../services/user_session.dart';
import '../widgets/form_organisation.dart';


class CustomSearchBar extends StatefulWidget {

/*
  final AuthenticatedUser authenticatedUser;

  const CustomSearchBar({Key? key, required this.authenticatedUser}) : super(key: key);*/
  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool isDark = false;
  late ParticularsManagerService particularsService;
  late AuthenticatedUser authenticatedUser;
  late OrganisationsManagerService organisationsService;
  late DocumentsManagerService documentsService;

  List<Organisation> allOrgs = [];
  late List<Organisation> org = [];


  @override
  void initState() {
    super.initState();
    try {
      authenticatedUser = UserSession.currentUser;
      // Utilisez currentUser ici
    } catch (e) {
      // Gérez l'erreur si aucun utilisateur n'est connecté
    }
    _initializationAsync();


  }

  Future<void> _initializationAsync() async {
    String addressPriveeServer = dotenv.env['PKEY_SERVER'] ?? "";
    Web3Connection web3Conn = new Web3Connection("http://${dotenv.get('GANACHE_HOST')}:${dotenv.get('GANACHE_PORT')}", "ws://${dotenv.get('GANACHE_HOST')}:${dotenv.get('GANACHE_PORT')}", addressPriveeServer);
    particularsService = new ParticularsManagerService(web3Conn);
    organisationsService = new OrganisationsManagerService(web3Conn);
    documentsService = new DocumentsManagerService(web3Conn);
    EthereumAddress contractAddr = await web3Conn.getContractAddress("DocumentsManager");
    await particularsService.initializeContract(); // Maybe show requests also
    await documentsService.initializeContract();
    await organisationsService.initializeContract();

    //initialisation liste
    List<Organisation> allOrgs = await organisationsService.getAllOrganisations(EthPrivateKey.fromHex(authenticatedUser.privateKey));


    print("je passe ici");
    setState(() {
      org=allOrgs;

    });

    print(org);
    print(org.length);


  }




  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light);

    return SearchAnchor(

        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            hintText: "Cherchez un organisme...",
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),

            onTap: () {
              controller.openView();

            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
          );
        }, suggestionsBuilder:
        (BuildContext context, SearchController controller) {
      return List<ListTile>.generate(org.length, (int index) {
        final String item = org[index].name;
        return ListTile(
          title: Text(item),
          onTap: () {
            setState(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FormOrgScreen(selectedOrganisation: org[index]),
                ),
              );
            });
          },
        );
      });
    });
  }
}