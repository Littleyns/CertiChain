import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import '../models/Document.dart';
import '../models/TemplateDocument.dart';
import '../services/web3_connection.dart';
import '../services/web3_service.dart';

class BlockchainScreen extends StatefulWidget {
  @override
  _BlockchainScreenState createState() => _BlockchainScreenState();
}

enum SearchFilter { address, name }

class _BlockchainScreenState extends State<BlockchainScreen> {
  late Web3Service web3Service;
  SearchFilter selectedFilter = SearchFilter.address;
  TextEditingController searchController = TextEditingController();
  late List<Document> particularDocuments = [];

  @override
  void initState() {
    super.initState();
    _initializationAsync();


  }
  Future<void> _initializationAsync() async {
    String addressPriveeServer = "0x85289cd8817f6df013284fb557cfdb5b9feada4f9556be58594c2c9ac2afe970";
    Web3Connection web3Conn = new Web3Connection("http://127.0.0.1:7545", "ws://127.0.0.1:7545", addressPriveeServer);
    web3Service = new Web3Service(web3Conn);
    EthereumAddress contractAddr = await web3Conn.getContractAddress("DocumentsManager");
    await web3Service.initializeContract("DocumentsManager", contractAddr);
    List<Document> pdocs = await web3Service.getAllDocuments();
    print(pdocs);
    setState(() {
      particularDocuments = pdocs;
    });
  }

  Future<void> exploreData() async {
    final searchValue = searchController.text.trim();

    if (searchValue.isEmpty) {
      // Gérer le cas où la valeur de recherche est vide.
      return;
    }

    if (selectedFilter == SearchFilter.address) {
      // Recherche par adresse
      await exploreDataByAddress(searchValue);
    } else {
      // Recherche par nom
      await exploreDataByName(searchValue);
    }
  }

  Future<void> exploreDataByAddress(String address) async {
    List<TemplateDocument> templateDocuments = await web3Service.getOrgTemplateDocuments(address);


  }

  Future<void> exploreDataByName(String name) async {
    // ... (même code que précédemment)
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
                child: Text(filter == SearchFilter.address ? 'Adresse' : 'Nom'),
              ))
                  .toList(),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(labelText: selectedFilter == SearchFilter.address ? 'Adresse' : 'Nom'),
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
    if (particularDocuments.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        scrollDirection: Axis.horizontal, // Définissez la direction de défilement sur horizontal
        itemCount: particularDocuments.length,
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
                  Text('docId: ${particularDocuments[index].docId}'),
                  SizedBox(height: 8.0),
                  Text('templateDoc: ${particularDocuments[index].templateDoc}'),
                  SizedBox(height: 8.0),
                  Text('description: ${particularDocuments[index].description}'),
                  SizedBox(height: 8.0),
                  Text('owner: ${particularDocuments[index].particularAddress}'),
                  SizedBox(height: 8.0),
                  Text('org transmitter: ${particularDocuments[index].organisationAddress}'),
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
