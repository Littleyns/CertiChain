import 'package:chatflutter/models/AuthenticatedUser.dart';
import 'package:chatflutter/models/Particular.dart';
import 'package:chatflutter/models/TemplateDocument.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import '../../models/Document.dart';
import '../../models/Organisation.dart';
import '../../services/organisations_manager_service.dart';
import '../../services/particulars_manager_service.dart';
import '../../services/requests_manager_service.dart';
import '../../services/user_session.dart';
import '../../services/web3_connection.dart';
// Fonction pour afficher le popup
void _showPopupDocRequested(BuildContext context, TemplateDocument tdoc, Organisation owner) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Demande de document effectuée'),
        content: Row(children: [Text('Vous avez demandé le document :'),Text('${tdoc.name}',style: const TextStyle(
          fontSize: 15.0, fontWeight: FontWeight.bold)),
            Text(" à "),
            Text('${owner.name}',style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold))
      ],),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Code à exécuter lorsque le bouton est pressé
              Navigator.of(context).pop(); // Pour fermer le popup
            },
            child: Text('Fermer'),
          ),
        ],
      );
    },
  );
}
class FormOrgScreen extends StatefulWidget {
  final Organisation selectedOrganisation;
  const FormOrgScreen(
      {Key? key, required this.selectedOrganisation}) : super(key: key);

  @override
  State<FormOrgScreen> createState() => _FormOrgScreenState();
}

class _FormOrgScreenState extends State<FormOrgScreen> {
  final TextEditingController _searchController = TextEditingController();

  int hoveredIndex = -1;

  bool isFavorite = false;
  late List<TemplateDocument> _templateDocuments = [];
  late AuthenticatedUser user;
  late OrganisationsManagerService organisationService; // Ajout de la variable pour la connexion Web3
  late ParticularsManagerService particularsService;
  late RequestsManagerService requestsService;

  @override
  void initState() {
    super.initState();
    try {
      user = UserSession.currentUser;
      // Utilisez currentUser ici
    } catch (e) {
      // Gérez l'erreur si aucun utilisateur n'est connecté
    }
    _initializationAsync();
  }

  Future<void> _initializationAsync() async {
    Web3Connection web3Conn = new Web3Connection("http://${dotenv.get('GANACHE_HOST')}:${dotenv.get('GANACHE_PORT')}", "ws://${dotenv.get('GANACHE_HOST')}:${dotenv.get('GANACHE_PORT')}", dotenv.get('PKEY_SERVER'));
    particularsService = new ParticularsManagerService(web3Conn);
    organisationService = new OrganisationsManagerService(web3Conn);
    requestsService = new RequestsManagerService(web3Conn);
    await particularsService.initializeContract();
    await organisationService.initializeContract();
    await requestsService.initializeContract();
    bool orgIsFavourite = await particularsService.orgIsFavourite(EthPrivateKey.fromHex(user.privateKey), widget.selectedOrganisation.orgAddress);
    List<TemplateDocument> orgTemplateDocuments = await organisationService.getOrgTemplateDocuments(widget.selectedOrganisation.orgAddress);
    setState(() {
      isFavorite = orgIsFavourite;
      _templateDocuments = orgTemplateDocuments;
    });
  }

  List<TemplateDocument> filteredList = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Scaffold(

        appBar: AppBar(
          actions:[IconButton( onPressed: () {

            Navigator.of(context).pop(true);
            }, icon: Icon(Icons.close),iconSize: 36.0,)],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.selectedOrganisation.name,
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      // Toggle the favorite state
                      setState(() {
                        if(isFavorite){
                          particularsService.removeFavouriteOrg(EthPrivateKey.fromHex(user.privateKey), widget.selectedOrganisation.orgAddress);
                        }else{
                          particularsService.addFavouriteOrg(EthPrivateKey.fromHex(user.privateKey), widget.selectedOrganisation.orgAddress);
                        }
                        isFavorite = !isFavorite;

                      });
                    },
                  ),
                   Text(
                    isFavorite ? "Added to your favorites!": "Removed from your favorites",
                    style: TextStyle(fontSize: 10.0, color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
          leading: const CircleAvatar(
            // Your photo or icon goes here
            backgroundImage: AssetImage('assets/images/educationIcon.png'),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Form(
                child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search in organism documents',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length > 1) {
                      setState(() {
                        filteredList = _templateDocuments.where((item) =>
                                item.name.toLowerCase().contains(value.toLowerCase()) ||
                                item.id.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                    } else {
                      // Si le champ de recherche est vide, réinitialisez la liste filtrée
                      setState(() {
                        filteredList = [];
                      });
                    }
                  },
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(

                    child: Container(
                      padding:EdgeInsets.all(8.0),
                      color: Colors.blueGrey[100],
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,

                        children: List.generate(
                          filteredList.length > 0
                              ? filteredList.length
                              : _templateDocuments.length,
                          (index) => InkWell(
                            onTap: () {
                              // Action lorsque l'élément est cliqué
                              requestsService.requestDocument(EthPrivateKey.fromHex(user.privateKey), widget.selectedOrganisation.orgAddress, _templateDocuments[index].id);
                              _showPopupDocRequested(context,_templateDocuments[index],widget.selectedOrganisation);
                              print('Item clicked: ${_templateDocuments[index]}');
                            },
                            onHover: (isHovered) {
                              // Mise à jour de l'état de survol
                              setState(() {
                                hoveredIndex = isHovered ? index : -1;
                              });
                            },
                            child: Container(

                              margin: const EdgeInsets.only(bottom: 8.0),
                              color: hoveredIndex == index ? Colors.black12 : Colors.white60,
                              child: ListTile(
                                trailing: Icon(Icons.arrow_outward),
                                //title: filteredList.length>0? Text(filteredList[index]): Text(myList[index]),
                                title: filteredList.length > 0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(filteredList[index].name),
                                          Text(
                                            'ref: ${filteredList[index].id}',
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(_templateDocuments[index].name),
                                          Text(
                                            'ref: ${_templateDocuments[index].id}',
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
