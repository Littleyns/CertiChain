import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/web3dart.dart';

import '../models/Document.dart';
import '../services/documents_manager_service.dart';
import '../services/organisations_manager_service.dart';
import '../services/particulars_manager_service.dart';
import '../services/web3_connection.dart';

class BlockchainScreen extends StatefulWidget {
  @override
  _BlockchainScreenState createState() => _BlockchainScreenState();
}

enum SearchFilter { OwnerAddress, OrgAddress, TemplateDocName }

class _BlockchainScreenState extends State<BlockchainScreen> {
  late ParticularsManagerService particularsService;
  late OrganisationsManagerService organisationsService;
  late DocumentsManagerService documentsService;
  SearchFilter selectedFilter = SearchFilter.OwnerAddress;
  TextEditingController searchController = TextEditingController();
  late List<Document> displayedDocuments = [];
  late List<Document> baseDocs;
  @override
  void initState() {
    super.initState();
    _initializationAsync();


  }
  Future<void> _initializationAsync() async {
    String addressPriveeServer = dotenv.get('PKEY_SERVER');
    Web3Connection web3Conn = new Web3Connection("http://127.0.0.1:7545", "ws://127.0.0.1:7545", addressPriveeServer);
    particularsService = new ParticularsManagerService(web3Conn);
    organisationsService = new OrganisationsManagerService(web3Conn);
    documentsService = new DocumentsManagerService(web3Conn);
    EthereumAddress contractAddr = await web3Conn.getContractAddress("DocumentsManager");
    await particularsService.initializeContract(); // Maybe show requests also
    await documentsService.initializeContract();
    await organisationsService.initializeContract();
    baseDocs = await particularsService.getAllParticularsDocuments(); // Ajouter une limite
    setState(() {
      displayedDocuments = baseDocs;
    });
  }

  Future<void> exploreData() async {
    final searchValue = searchController.text.trim();

    if (searchValue.isEmpty) {
      setState(() {
        displayedDocuments = baseDocs;
      });
      return;
    }

    if (selectedFilter == SearchFilter.OwnerAddress) {
      // Recherche par adresse
      await exploreDataByOwnerAddress(searchValue);
    } else if(selectedFilter == SearchFilter.OrgAddress){
      // Recherche par nom
      await exploreDataByOrgAddress(searchValue);
    }else if(selectedFilter == SearchFilter.TemplateDocName){
      await exploreDataByTemplateDocName(searchValue);
    }

  }

  Future<void> exploreDataByOwnerAddress(String address) async {
    List<Document> documents = await particularsService.getParticularDocuments(address);

    setState(() {
      displayedDocuments = documents;
    });
    print(documents);

  }

  Future<void> exploreDataByOrgAddress(String address) async {
    List<Document> orgDocuments = await organisationsService.getOrgDocuments(address);
    setState(() {
      displayedDocuments = orgDocuments;
    });
  }

  Future<void> exploreDataByTemplateDocName(String name) async {
    List<Document> documents = await documentsService.getDocumentsByTemplateName(name);
    setState(() {
      displayedDocuments = documents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment:MainAxisAlignment.center ,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            DropdownButton<SearchFilter>(
              value: selectedFilter,
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
              items: SearchFilter.values
                  .map((filter) => DropdownMenuItem(
                value: filter,
                child: Text(filter == SearchFilter.OwnerAddress ? 'Owner address' : (filter == SearchFilter.OrgAddress ? 'Org Address': 'Template doc Name')),
              ))
                  .toList(),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(labelText: selectedFilter == SearchFilter.OwnerAddress ? 'Owner address' : (selectedFilter == SearchFilter.OrgAddress ? 'Org Address': 'Template doc Name')),
                onSubmitted: (value) => exploreData(),
              ),
            ),


          ],
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: exploreData,
          child: Text('Explorer les données'),
        ),
        SizedBox(height: 32),
        Container(
          width:double.infinity,
          height:300,
          child:_buildTemplateDocumentsGrid(),
        ),

      ],
    );
  }
  Widget _buildTemplateDocumentsGrid() {
    if (displayedDocuments.isEmpty) {
      return const Text(
        "Aucune transaction trouvée avec les filtres courant"
      );
    } else {
      return ListView.builder(
        scrollDirection: Axis.horizontal, // Définissez la direction de défilement sur horizontal
        itemCount: displayedDocuments.length,
        itemBuilder: (context, index) {
          return Row(
            children: [Container(
              width: 300.0, // Largeur fixe
              height: 300.0, // Hauteur fixe
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('docId: ${displayedDocuments[index].docId}'),
                  SizedBox(height: 8.0),
                  Text('templateDoc: ${displayedDocuments[index].templateDocName}'),
                  SizedBox(height: 8.0),
                  Text('description: ${displayedDocuments[index].description}'),
                  SizedBox(height: 8.0),
                  Text('owner: ${displayedDocuments[index].ParticularOwner}'),
                  SizedBox(height: 8.0),
                  Text('org transmitter: ${displayedDocuments[index].organisationEmitter}'),
                  SizedBox(height: 8.0),
                  Text('Expiration date: ${displayedDocuments[index].expirationDate.toInt() == -1 ? "-": new DateTime.fromMicrosecondsSinceEpoch(displayedDocuments[index].expirationDate.toInt())}'),
                ],
              ),
            ),
              Container(
                width:20,
                child: Divider(
                  height: 1, // Hauteur du Divider (trait horizontal)

                  color: Colors.black, // Couleur du Divider
                ),
              ),],
          );
        },
      );

    }
  }


}

void main() {
  runApp(MaterialApp(
    home: BlockchainScreen(),
  ));
}
