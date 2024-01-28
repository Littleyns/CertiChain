
import 'package:chatflutter/screens/particular/search_screen.dart';
import 'package:chatflutter/services/requests_manager_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import '../models/AuthenticatedUser.dart';
import '../models/Organisation.dart';
import '../services/organisations_manager_service.dart';
import '../services/user_session.dart';
import '../services/web3_connection.dart';
import '../widgets/organisation/document_grant_form.dart';
import '../widgets/particular/custom_searchbar.dart';
import 'common/blockchain_screen.dart';
import 'organisation/create_screen.dart';
import 'organisation/home_screen.dart';

class MainOrganisations extends StatefulWidget {
  const MainOrganisations({super.key, required this.title});
  final String title;

  @override
  State<MainOrganisations> createState() => _MainOrganisationsState();
}

class _MainOrganisationsState extends State<MainOrganisations> {
  int _currentScreenIndex = 0;
  late AuthenticatedUser currentUser;

  Widget _buildBody() {
    switch (_currentScreenIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return DocumentGrantForm();
      case 2:
        return BlockchainScreen();
      default:
        return Container();
    }
  }
  @override
  void initState(){

    super.initState();
    // Simulation d'une authentification
    try {
      currentUser = UserSession.currentUser;
      // Utilisez currentUser ici
    } catch (e) {
      // Gérez l'erreur si aucun utilisateur n'est connecté
    }
    _initializationAsync();
  }
  Future<void> _initializationAsync() async {
    // FIXME! to remove later after implementing search organisation screen
    Web3Connection web3Conn = new Web3Connection("http://${dotenv.env['GANACHE_HOST']}:${dotenv.env['GANACHE_PORT']}", "ws://${dotenv.env['GANACHE_HOST']}:${dotenv.env['GANACHE_PORT']}", dotenv.env['PKEY_SERVER']??"");

    OrganisationsManagerService organisationsService = new OrganisationsManagerService(web3Conn);
    await organisationsService.initializeContract();
  }
  @override
  Widget build(BuildContext context) {
    if(currentUser.type == UserType.Particular){

    } else {

    }
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Hauteur personnalisée de la barre de recherche
        child: Image.asset(
          'assets/images/logo.png',
          width: 100, // Largeur personnalisée
          height: 100, // Hauteur personnalisée
          fit: BoxFit.contain, // Ajuster l'image dans les limites définies
        )
      ),
      body:Container(padding: EdgeInsets.all(16.0),child:_buildBody()),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey[50],
        fixedColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: _currentScreenIndex,
        onTap: (index) {
          setState(() {
            _currentScreenIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/blockchain_icon.png',
              width: 25.0, // Ajustez la largeur selon vos besoins
              height: 25.0, // Ajustez la hauteur selon vos besoins
            ),
            label: 'CertiChain',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}