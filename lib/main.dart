import 'package:chatflutter/screens/blockchain_screen.dart';
import 'package:chatflutter/screens/create_screen.dart';
import 'package:chatflutter/screens/home_screen.dart';
import 'package:chatflutter/screens/search_screen.dart';
import 'package:chatflutter/services/organisations_manager_service.dart';
import 'package:chatflutter/services/web3_connection.dart';
import 'package:chatflutter/widgets/custom_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import 'models/AuthenticatedUser.dart';
import 'models/Organisation.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.light(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo test Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        return CreateScreen(authenticatedUser: currentUser,organisation: allOrgs[0]);
      case 3:
        return BlockchainScreen();
      default:
        return Container();
    }
  }
  @override
  void initState(){
    super.initState();
    currentUser = new AuthenticatedUser(publicKey: '0x0df08E74FFd70cd5D4C28D5bA6261755040E69d1', privateKey: '0x3537081c99dff4618e1f3de8382912a1d7ccf651ade0e015b45b79cf25808384', type: UserType.Particular);
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Hauteur personnalisée de la barre de recherche
        child: Padding(
            padding: const EdgeInsets.all(16),
            child:CustomSearchBar()),
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
