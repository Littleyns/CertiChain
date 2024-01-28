import 'package:chatflutter/widgets/particular/FavOrgsElevatedBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:chatflutter/services/web3_connection.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import '../../models/AuthenticatedUser.dart';
import '../../models/Organisation.dart';
import '../../services/documents_manager_service.dart';
import '../../services/organisations_manager_service.dart';
import '../../services/particulars_manager_service.dart';
import '../../services/user_session.dart';
import '../../widgets/particular/custom_searchbar.dart';
import '../../widgets/particular/form_organisation.dart';




class SearchScreen extends StatefulWidget {


  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late ParticularsManagerService particularsService;
  late AuthenticatedUser authenticatedUser;
  late OrganisationsManagerService organisationsService;
  late DocumentsManagerService documentsService;

  late List<Organisation> allOrgs;
  List<Organisation> org = [];
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
    allOrgs = await organisationsService.getAllOrganisations(EthPrivateKey.fromHex(authenticatedUser.privateKey));
    org = allOrgs;
    setState(() {
      org=allOrgs;

    });

  }

  void filterOrgs(List<Organisation> filteredOrgs){
    setState((){
      org=filteredOrgs;
    });
  }


  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SearchBar(
                hintText: "Cherchez un organisme...",
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),

                onTap: () {
                  print("lol");

                },
                onChanged: (searchText) {
                  List<Organisation> filteredOrgs = [];
                  if (searchText.isEmpty || searchText=="") {
                     // Si la barre de recherche est vide, affichez toutes les organisations
                    setState(() {
                      org = allOrgs;
                    });
                  } else {
                    // Filtrer la liste des organisations
                    filteredOrgs = allOrgs.where((org) {
                      return org.name.toLowerCase().contains(searchText.toLowerCase());
                      // Remplacez 'name' par la propriété appropriée de votre objet Organisation
                    }).toList();
                    setState(() {
                      org = filteredOrgs;
                    });
                  }

                  print("filtered${filteredOrgs}");
                  // Mettre à jour la liste des organisations affichées


                },
                leading: const Icon(Icons.search),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                shrinkWrap: true,

                children: FavOrgsElevatedBuilder.buildButtons(
                  organizations: org,
                  onPressed: (Organisation organization) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FormOrgScreen(selectedOrganisation: organization),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      );
  }
}