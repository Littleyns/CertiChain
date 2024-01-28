
import 'package:chatflutter/screens/particular/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import '../models/AuthenticatedUser.dart';
import '../models/Organisation.dart';
import '../services/organisations_manager_service.dart';
import '../services/user_session.dart';
import '../services/web3_connection.dart';
import '../widgets/particular/custom_searchbar.dart';
import 'common/blockchain_screen.dart';
import 'organisation/create_screen.dart';
import 'particular/home_screen.dart';

class MainParticulars extends StatefulWidget {
  const MainParticulars({super.key, required this.title});
  final String title;

  @override
  State<MainParticulars> createState() => _MainParticularsState();
}

class _MainParticularsState extends State<MainParticulars> {
  int _currentScreenIndex = 0;
  late AuthenticatedUser currentUser;
  late List<Organisation> allOrgs = []; //FIXME! to remove later after implementing search organisation screen

  Widget _buildBody() {
    switch (_currentScreenIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return SearchScreen();
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
    UserSession.loginUser(new AuthenticatedUser(publicKey: '0x0df08E74FFd70cd5D4C28D5bA6261755040E69d1', privateKey: '0x3537081c99dff4618e1f3de8382912a1d7ccf651ade0e015b45b79cf25808384', type: UserType.Particular));
    try {
      currentUser = UserSession.currentUser;
      // Utilisez currentUser ici
    } catch (e) {
      // Gérez l'erreur si aucun utilisateur n'est connecté
    }
    allOrgs.add(new Organisation(orgAddress: '12345',domain: Domain.Education,name: "placeholder org(noOrgsFound)"));
    _initializationAsync();
  }
  Future<void> _initializationAsync() async {
    // FIXME! to remove later after implementing search organisation screen
    Web3Connection web3Conn = new Web3Connection("http://${dotenv.env['GANACHE_HOST']}:${dotenv.env['GANACHE_PORT']}", "ws://${dotenv.env['GANACHE_HOST']}:${dotenv.env['GANACHE_PORT']}", dotenv.env['PKEY_SERVER']??"");

    OrganisationsManagerService organisationsService = new OrganisationsManagerService(web3Conn);
    await organisationsService.initializeContract();
    allOrgs = await organisationsService.getAllOrganisations(EthPrivateKey.fromHex(currentUser.privateKey));
    // Handle the case of no orgs found or not filled blockchain
    if(allOrgs.length == 0){
      allOrgs.add(new Organisation(orgAddress: '12345',domain: Domain.Education,name: "placeholder org(noOrgsFound)"));
    }
  }
  @override
  Widget build(BuildContext context) {
    if(currentUser.type == UserType.Particular){

    } else {

    }
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Hauteur personnalisée de la barre de recherche
        child: Container(
          width:150,
          height:100,
          child: Image.asset(
            'assets/images/logo.png',
            width:150,
            height:100,
            fit: BoxFit.fitHeight, // Ajuster l'image dans les limites définies
          ),
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
            icon: Icon(Icons.search),
            label: 'Search',
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