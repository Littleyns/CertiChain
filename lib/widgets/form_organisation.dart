import 'package:chatflutter/models/Particular.dart';
import 'package:flutter/material.dart';

import '../models/Document.dart';
import '../models/Organisation.dart';
import '../services/organisations_manager_service.dart';
import '../services/web3_connection.dart';

class FormOrgScreen extends StatefulWidget {
  final Organisation selectedOrganisation;
  final Particular user;

  const FormOrgScreen(
      {Key? key, required this.selectedOrganisation, required this.user}) : super(key: key);

  @override
  State<FormOrgScreen> createState() => _FormOrgScreenState();
}

class _FormOrgScreenState extends State<FormOrgScreen> {
  final TextEditingController _searchController = TextEditingController();

  int hoveredIndex = -1;

  bool isFavorite = false;
  late List<Document> _documents = [];
  late String _orgAddress;
  late String _name;
  late OrganisationsManagerService _orgService; // Ajout de la variable pour la connexion Web3

  @override
  void initState() {
    super.initState();
    // Initialisation de la connexion Web3
    Web3Connection web3Connection = Web3Connection('http://your_rpc_url', 'ws://your_ws_url', 'your_private_key');
    web3Connection.init();
    // Initialisation du service Web3
    _orgService = OrganisationsManagerService(web3Connection);

    _name = widget.selectedOrganisation.name;
    _getOrgDocuments();

    // Vérifier si l'organisation est en favori pour cet utilisateur
    isFavorite = widget.user.isFavorite(widget.selectedOrganisation);
  }

  // Fonction pour récupérer les documents de l'organisation
  Future<void> _getOrgDocuments() async {
    _orgAddress = widget.selectedOrganisation.orgAddress;
    try {
      List<Document> orgDocuments =
      await _orgService.getOrgDocuments(_orgAddress);
      setState(() {
        _documents = orgDocuments;
      });
    } catch (e) {
      print(e);
    }
  }

  List<Document> filteredList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _name,
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
                      isFavorite = !isFavorite;
                      if (isFavorite) {
                        widget.user.favouriteOrgs.add(widget.selectedOrganisation);
                      } else {
                        widget.user.favouriteOrgs.remove(widget.selectedOrganisation);
                      }
                    });
                  },
                ),
                const Text(
                  "Added to your favories!",
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
                      filteredList = _documents.where((item) =>
                      item.description.toLowerCase().contains(value.toLowerCase()) ||
                          item.docId.toLowerCase().contains(value.toLowerCase()))
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                      filteredList.length > 0
                          ? filteredList.length
                          : _documents.length,
                          (index) => InkWell(
                        onTap: () {
                          // Action lorsque l'élément est cliqué
                          print('Item clicked: ${_documents[index]}');
                        },
                        onHover: (isHovered) {
                          // Mise à jour de l'état de survol
                          setState(() {
                            hoveredIndex = isHovered ? index : -1;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          color: hoveredIndex == index ? Colors.black12 : null,
                          child: ListTile(
                            //title: filteredList.length>0? Text(filteredList[index]): Text(myList[index]),
                            title: filteredList.length > 0
                                ? Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(filteredList[index].description),
                                Text(
                                  'ref: ${filteredList[index].docId}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            )
                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(_documents[index].description),
                                Text(
                                  'ref: ${_documents[index].docId}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
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
    );
  }
}
