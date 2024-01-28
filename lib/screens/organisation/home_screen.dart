import 'package:chatflutter/services/requests_manager_service.dart';
import 'package:chatflutter/widgets/organisation/RequestSendedElevatedBuilder.dart';
import 'package:chatflutter/widgets/organisation/RequestReceivedElevatedBuilder.dart';
import 'package:chatflutter/widgets/organisation/TDocsElevatedBuilder.dart';
import 'package:flutter/material.dart';
import 'package:chatflutter/widgets/particular/DocumentsElevatedBuilder.dart';
import 'package:chatflutter/services/web3_connection.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import '../../models/AuthenticatedUser.dart';
import '../../models/DocumentRequest.dart';
import '../../widgets/organisation/document_grant_form.dart';
import '../../widgets/particular/FavOrgsElevatedBuilder.dart';
import '../../models/GrantRequest.dart';
import '../../models/Organisation.dart';
import '../../models/TemplateDocument.dart';
import '../../models/Document.dart';
import '../../services/organisations_manager_service.dart';
import '../../services/particulars_manager_service.dart';
import '../../services/user_session.dart';
import '../../widgets/particular/DocRequestsSendedElevatedBuilder.dart';
import '../../widgets/particular/GrantRequestsReceivedElevatedBuilder.dart';
import '../../widgets/particular/form_organisation.dart';
import '../organisation/create_screen.dart';

class HomeScreen extends StatefulWidget {



  const HomeScreen({Key? key}) : super(key: key);


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late OrganisationsManagerService orgService;
  late RequestsManagerService requestsService;
  late AuthenticatedUser authenticatedUser;

  late List<GrantRequest> docRequestsSended =[];
  late List<DocumentRequest> docRequestsReceived =[];
  late List<TemplateDocument> orgTemplateDocs = [];



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
    orgService = new OrganisationsManagerService(web3Conn);
    requestsService = new RequestsManagerService(web3Conn);
    await orgService.initializeContract();
    await requestsService.initializeContract();

    //initialisation liste
    orgTemplateDocs = await orgService.getOrgTemplateDocuments(authenticatedUser.publicKey);
    docRequestsReceived = await orgService.getOrgRequestsReceived(EthPrivateKey.fromHex(authenticatedUser.privateKey),authenticatedUser.publicKey);
    docRequestsSended = await orgService.getOrgGrantRequestsSended(EthPrivateKey.fromHex(authenticatedUser.privateKey),authenticatedUser.publicKey);

    if(mounted) {
      setState(() {
        orgTemplateDocs = orgTemplateDocs;
        docRequestsReceived = docRequestsReceived;
        docRequestsSended = docRequestsSended;
      });
    }
  }
  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("home screen state updated");
  }

  Future<void> refreshReceivedDocs() async {
    List<DocumentRequest> docRequestsReceived = await orgService.getOrgRequestsReceived(EthPrivateKey.fromHex(authenticatedUser.privateKey),authenticatedUser.publicKey);
    setState(() {
      docRequestsReceived=docRequestsReceived;
    });
  }

  void refreshHomeScreen() async {
    orgTemplateDocs = await orgService.getOrgTemplateDocuments(authenticatedUser.publicKey);
    docRequestsReceived = await orgService.getOrgRequestsReceived(EthPrivateKey.fromHex(authenticatedUser.privateKey),authenticatedUser.publicKey);
    docRequestsSended = await orgService.getOrgGrantRequestsSended(EthPrivateKey.fromHex(authenticatedUser.privateKey),authenticatedUser.publicKey);
    setState(() {
      orgTemplateDocs = orgTemplateDocs;
      docRequestsReceived = docRequestsReceived;
      docRequestsSended=docRequestsSended;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: 'Template Documents'),
                Tab(text: 'Requests'),

              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [

            if (orgTemplateDocs.isNotEmpty) _buildPage1(orgTemplateDocs ,context),
            if (orgTemplateDocs.isEmpty)   Container(
              color: Colors.white,
              child: const Center(
                child: Text("Aucun template document"),
              ),
            ),



            if (docRequestsReceived.isNotEmpty | docRequestsSended.isNotEmpty) _buildPage2(docRequestsReceived,docRequestsSended,requestsService,context),
            if (docRequestsReceived.isEmpty | docRequestsSended.isEmpty) Container(
              color: Colors.white,
              child: const Center(
                child: Text("Aucune requête à afficher"),
              ),
            ),

          ],
        ),
      ),
    );
  }

  static Widget _buildPage1(List<TemplateDocument> orgTemplateDocs, BuildContext context) {
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
              children: TDocsElevatedBuilder.buildButtons(
                tDocs: orgTemplateDocs,
                onPressed: (TemplateDocument tdoc) {
                  // Action lors du clic sur un bouton
                },
              ),
            ),
          ],
        ),
      );
  }
  static Widget _buildPage2(List<DocumentRequest> requestReceived, List<GrantRequest> requestsSended,RequestsManagerService requestsService, context) {
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

              children: RequestSendedElevatedBuilder.buildButtons(
                grantRequests: requestsSended,
                onPressed: (GrantRequest request) {

                },

              )+RequestReceivedElevatedBuilder.buildButtons(
                  documentRequests: requestReceived,
                  reqService : requestsService,
                  onPressed: (DocumentRequest requestReceived) {

                  },
                  onAccepted: (AuthenticatedUser user, DocumentRequest requestReceived, RequestsManagerService reqService) async {
                    // rediriger vers un formulaire
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DocumentGrantForm(docRequest: requestReceived,),
                    ),);
                    //await reqService.acceptDocumentRequest(EthPrivateKey.fromHex(user.privateKey), requestReceived.docRequestId);
                    print("Document accepté");
                    await context.state.refreshHomeScreen();

                  },

                  onRefused: (AuthenticatedUser user, DocumentRequest requestReceived, RequestsManagerService reqService) async {
                    await reqService.rejectDocumentRequest(EthPrivateKey.fromHex(user.privateKey), requestReceived.docRequestId);
                    print("Document accepté");
                    await context.state.refreshHomeScreen();
                    print("doc refused");
                  }
              ),
            )


          ],
        ),
      ),
    );
  }



}
