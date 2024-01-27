import 'package:flutter/material.dart';
import 'package:chatflutter/models/ElevatedButtonBuilder.dart';
import 'package:chatflutter/services/web3_connection.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import '../models/AuthenticatedUser.dart';
import '../models/DocumentRequest.dart';
import '../models/ElevatedButtonBuilder2.dart';
import '../models/ElevatedButtonBuilder3.dart';
import '../models/ElevatedButtonBuilder4.dart';
import '../models/GrantRequest.dart';
import '../models/Organisation.dart';
import '../models/TemplateDocument.dart';
import '../models/Document.dart';
import '../services/organisations_manager_service.dart';
import '../services/particulars_manager_service.dart';
import 'create_screen.dart';

class HomeScreen extends StatefulWidget {

  final AuthenticatedUser authenticatedUser;

  const HomeScreen({Key? key, required this.authenticatedUser}) : super(key: key);


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ParticularsManagerService particularsService;

  List<Document> documentsParticulier = [];
  List<Organisation> FavouriteOrgs = [];
  List<DocumentRequest> docRequestsSended =[];
  List<GrantRequest> docRequests =[];


  late List<Document> baseDocs;
  late List<Document> displayedDocuments = [];
  late List<Organisation> orgDocuments = [];
  late List<DocumentRequest> request =[];
  late List<GrantRequest> dreq =[];

  late List<Object> test=[];
  List<Object> concatenatedList = [];

  @override
  void initState() {
    super.initState();
    _initializationAsync();


  }

  //ici je recupere la liste des docs

  Future<void> _initializationAsync() async {
    String addressPriveeServer = dotenv.get('PKEY_SERVER');
    Web3Connection web3Conn = new Web3Connection("http://${dotenv.get('GANACHE_HOST')}:${dotenv.get('GANACHE_PORT')}", "ws://${dotenv.get('GANACHE_HOST')}:${dotenv.get('GANACHE_PORT')}", addressPriveeServer);
    particularsService = new ParticularsManagerService(web3Conn);
    OrganisationsManagerService organisationsService = new OrganisationsManagerService(web3Conn);
    await particularsService.initializeContract();
    EthereumAddress contractAddr = await web3Conn.getContractAddress("DocumentsManager");

    //initialisation liste
    List<Document> documentsParticulier =await particularsService.getParticularDocuments(widget.authenticatedUser.publicKey);
    List<Organisation> FavouriteOrgs = await particularsService.getFavouriteOrgs(EthPrivateKey.fromHex(widget.authenticatedUser.privateKey));
    List<DocumentRequest> docRequestsSended = await particularsService.getParticularDocRequestsSended(EthPrivateKey.fromHex(widget.authenticatedUser.privateKey));
    List<GrantRequest> docRequests = await particularsService.getParticularDocGrantRequestsReceived(EthPrivateKey.fromHex(widget.authenticatedUser.privateKey));

    // Ajouter une limite
    baseDocs = await particularsService.getAllParticularsDocuments();
    print("je passe ici");
    setState(() {
      displayedDocuments = baseDocs;
      displayedDocuments = documentsParticulier;
      orgDocuments = FavouriteOrgs;

      request=docRequestsSended;
      dreq=docRequests;

      //test=request+dreq;

    });
    print(documentsParticulier);
    print(FavouriteOrgs);

    print("ici je print");
    print(test);


  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: 'Certific'),
                Tab(text: 'Pending'),

                Tooltip(
                  message: 'Favorite organisms',
                  child: Tab(
                    text: 'Favorite \n organisms',
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [

            if (displayedDocuments.isNotEmpty) _buildPage1(displayedDocuments ,context),
            if (displayedDocuments.isEmpty)   Container(
              color: Colors.white,
              child: const Center(
                child: Text("Aucun certificat"),
              ),
            ),



            if (request.isNotEmpty) _buildPage2(request,dreq,context),
            if (request.isEmpty) Container(
              color: Colors.white,
              child: const Center(
                child: Text("Aucune requête en attente"),
              ),
            ),



            if (orgDocuments.isNotEmpty) _buildPage3(orgDocuments,context),
            if (orgDocuments.isEmpty) Container(
              color: Colors.white,
              child: const Center(
                child: Text("Vous n'avez aucune organisation en favori \npour ajouter en favori likez une organisation !"),
              ),
            ),



          ],
        ),
      ),
    );
  }

  static Widget _buildPage1(List<Document> documentsParticulier, BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            shrinkWrap: true,
            children: ElevatedButtonBuilder.buildButtons(
              documents: documentsParticulier,
              onPressed: (Document documentsParticulier) {

              },
            ),
            ),

        ],
      ),
    );
  }
  static Widget _buildPage2(List<DocumentRequest> request, List<GrantRequest> dreq, context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              shrinkWrap: true,

              children: ElevatedButtonBuilder3.buildButtons(
                documentRequests: request,
                onPressed: (DocumentRequest request) {

                },
              ),
            ),const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              shrinkWrap: true,

              children:
              ElevatedButtonBuilder4.buildButtons(
                grantRequests: dreq,
                onPressed: (GrantRequest dreq) {

                },
              ),
            )

          ],
        ),
      ),
    );;
  }


  static Widget _buildPage3(List<Organisation> FavouriteOrgs, BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            shrinkWrap: true,

            children: ElevatedButtonBuilder2.buildButtons(
              organizations: FavouriteOrgs,
              onPressed: (Organisation organization) {
                /*Navigator.of(context).push(

                  MaterialPageRoute(
                    builder: (context) => const CreateScreen(),
                  ),
                );*/
              },
            ),
            ),

        ],
      ),
    );
  }

/*
  final List<Widget> _pages = [
    _buildPage1(documentsParticulier),
    Container(
      color: Colors.green,
      child: const Center(
        child: Text('Page 2'),
      ),
    ),
    Container(
      color: Colors.orange,
      child: const Center(
        child: Text('Page 3'),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(

            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: 'Certific'),
                Tab(text: 'Pending'),
                Tooltip(
                  message: 'Favorite organisms',
                  child: Tab(
                    text: 'Favorite \n organisms',
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: _pages,
        ),
      ),
    );

  }


 static Widget _buildPage1() {
    return Container(
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Certific'),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            shrinkWrap: true,
            ListView.builder(
              itemCount: documentsParticulier.length,
              itemBuilder: (context, index) {
                return
              ElevatedButtonBuilder.build(
                label: documentsParticulier[index].templateDocName,
                onPressed: () {
                  // Do something when the new button is pressed
                },
              );


          ),
        ],
      ),
    );
  }

  static Widget _buildPage1(List<Document> documentsParticulier) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            shrinkWrap: true,
            children: ElevatedButtonBuilder.buildButtons(
              documentsParticulier,
              onPressed: () {
                // Do something when a button is pressed
              },
            ),
          ),
        ],
      ),
    );
  }*/
}
