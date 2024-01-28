import 'package:chatflutter/services/requests_manager_service.dart';
import 'package:flutter/material.dart';
import 'package:chatflutter/widgets/particular/ElevatedButtonBuilder.dart';
import 'package:chatflutter/services/web3_connection.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import '../../models/AuthenticatedUser.dart';
import '../../models/DocumentRequest.dart';
import '../../widgets/particular/ElevatedButtonBuilder2.dart';
import '../../models/GrantRequest.dart';
import '../../models/Organisation.dart';
import '../../models/TemplateDocument.dart';
import '../../models/Document.dart';
import '../../services/organisations_manager_service.dart';
import '../../services/particulars_manager_service.dart';
import '../../services/user_session.dart';
import '../../widgets/particular/ElevatedButtonBuilder3.dart';
import '../../widgets/particular/ElevatedButtonBuilder4.dart';
import '../../widgets/particular/form_organisation.dart';
import '../organisation/create_screen.dart';

class HomeScreen extends StatefulWidget {



  const HomeScreen({Key? key}) : super(key: key);


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ParticularsManagerService particularsService;
  late RequestsManagerService requestsService;
  late AuthenticatedUser authenticatedUser;
  List<Document> documentsParticulier = [];
  List<Organisation> FavouriteOrgs = [];
  List<DocumentRequest> docRequestsSended =[];
  List<GrantRequest> docRequests =[];


  late List<Document> displayedDocuments = [];
  late List<Organisation> orgDocuments = [];
  late List<DocumentRequest> request =[];
  late List<GrantRequest> dreq =[];

  late List<Object> test=[];
  List<Object> concatenatedList = [];

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

  //ici je recupere la liste des docs

  Future<void> _initializationAsync() async {
    String addressPriveeServer = dotenv.get('PKEY_SERVER');
    Web3Connection web3Conn = new Web3Connection("http://${dotenv.get('GANACHE_HOST')}:${dotenv.get('GANACHE_PORT')}", "ws://${dotenv.get('GANACHE_HOST')}:${dotenv.get('GANACHE_PORT')}", addressPriveeServer);
    particularsService = new ParticularsManagerService(web3Conn);
    requestsService = new RequestsManagerService(web3Conn);
    await particularsService.initializeContract();
    await requestsService.initializeContract();

    //initialisation liste
    List<Document> documentsParticulier =await particularsService.getParticularDocuments(authenticatedUser.publicKey);
    List<Organisation> FavouriteOrgs = await particularsService.getFavouriteOrgs(EthPrivateKey.fromHex(authenticatedUser.privateKey));
    List<DocumentRequest> docRequestsSended = await particularsService.getParticularDocRequestsSended(EthPrivateKey.fromHex(authenticatedUser.privateKey));
    List<GrantRequest> docRequests = await particularsService.getParticularDocGrantRequestsReceived(EthPrivateKey.fromHex(authenticatedUser.privateKey));


    print("je passe ici");
    setState(() {
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
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("home screen state updated");
  }

  Future<void> refreshGrantedDocs() async {
    List<GrantRequest> grantedDocRequests = await particularsService.getParticularDocGrantRequestsReceived(EthPrivateKey.fromHex(authenticatedUser.privateKey));
    setState(() {
      dreq=grantedDocRequests;
    });
  }

  void refreshHomeScreen() async {
    List<Document> documentsParticulier =await particularsService.getParticularDocuments(authenticatedUser.publicKey);
    List<Organisation> FavouriteOrgs = await particularsService.getFavouriteOrgs(EthPrivateKey.fromHex(authenticatedUser.privateKey));
    List<DocumentRequest> docRequestsSended = await particularsService.getParticularDocRequestsSended(EthPrivateKey.fromHex(authenticatedUser.privateKey));
    List<GrantRequest> docRequests = await particularsService.getParticularDocGrantRequestsReceived(EthPrivateKey.fromHex(authenticatedUser.privateKey));


    print("je passe ici");
    setState(() {
      displayedDocuments = documentsParticulier;
      orgDocuments = FavouriteOrgs;

      request=docRequestsSended;
      dreq=docRequests;

      //test=request+dreq;

    });
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
                Tab(text: 'Requests'),

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



            if (request.isNotEmpty) _buildPage2(request,dreq,requestsService,context),
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
    return

      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: ElevatedButtonBuilder.buildButtons(
                documents: documentsParticulier,
                onPressed: (Document document) {
                  // Action lors du clic sur un bouton
                },
              ),
            ),
          ],
        ),
      );
  }
  static Widget _buildPage2(List<DocumentRequest> request, List<GrantRequest> dreq,RequestsManagerService requestsService, context) {
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
            ),
          const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              shrinkWrap: true,

              children:
              ElevatedButtonBuilder4.buildButtons(
                grantRequests: dreq,
                reqService : requestsService,
                onPressed: (GrantRequest dreq) {

                },
                  onAccepted: (AuthenticatedUser user, GrantRequest dreq, RequestsManagerService reqService) async {
                      // Vous pouvez effectuer votre action ici (par exemple, accepter le document)
                      await reqService.acceptGrantedDocument(EthPrivateKey.fromHex(user.privateKey), dreq.grantRequestId);
                      print("Document accepté");
                      await context.state.refreshGrantedDocs();

                  },

                onRefused: (AuthenticatedUser user, GrantRequest dreq, RequestsManagerService reqService) async {
                  //reqService.acceptGrantedDocument(EthPrivateKey.fromHex(user.privateKey), dreq.grantRequestId);
                  await reqService.rejectDocumentGrant(EthPrivateKey.fromHex(user.privateKey), dreq.grantRequestId);
                  print("Document accepté");
                  await context.state.refreshGrantedDocs();
                  print("doc refused");
                }
              ),
            )

          ],
        ),
      ),
    );
  }


  static Widget _buildPage3(List<Organisation> FavouriteOrgs, context) {
    return
      SingleChildScrollView(
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
        
              children: ElevatedButtonBuilder2.buildButtons(
                organizations: FavouriteOrgs,
                onPressed: (Organisation organization) async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FormOrgScreen(selectedOrganisation: organization),
                    ),
                  );

                  context.state.refreshHomeScreen();
                },
              ),
              ),
        
          ],
        ),
            ),
      );
  }

}
