import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import '../models/AuthenticatedUser.dart';
import '../models/Organisation.dart';
import '../services/particulars_manager_service.dart';
import '../services/user_session.dart';
import '../services/web3_connection.dart';


class CreateScreen extends StatefulWidget {
  final Organisation organisation;
  const CreateScreen({Key? key, required this.organisation}) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _searchController = TextEditingController();
  late ParticularsManagerService particularsService;
  late AuthenticatedUser authenticatedUser;
  bool isFavorite = false;
  int hoveredIndex = -1;
  final List<String> myList = [
    'Item 1',
    'Avaler 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10',
    'Item 11',
    'Item 12',
  ];
  List<String> filteredList = [];




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
  Future<void> _initializationAsync() async {
    Web3Connection web3Conn = new Web3Connection("http://${dotenv.get('GANACHE_HOST')}:${dotenv.get('GANACHE_PORT')}", "ws://${dotenv.get('GANACHE_HOST')}:${dotenv.get('GANACHE_PORT')}", dotenv.get('PKEY_SERVER'));
    particularsService = new ParticularsManagerService(web3Conn);
    await particularsService.initializeContract(); // Maybe show requests also
    bool orgIsFavourite = await particularsService.orgIsFavourite(EthPrivateKey.fromHex(authenticatedUser.privateKey), widget.organisation.orgAddress);
    setState(() {
      isFavorite = orgIsFavourite;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  "3IL Ingenieur",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
                    if(isFavorite){
                      particularsService.removeFavouriteOrg(EthPrivateKey.fromHex(authenticatedUser.privateKey), widget.organisation.orgAddress);
                    }else{
                      particularsService.addFavouriteOrg(EthPrivateKey.fromHex(authenticatedUser.privateKey), widget.organisation.orgAddress);
                    }
                    setState(() {
                      isFavorite = !isFavorite;
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

      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //Row(
            //children: [
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
                onChanged: (value){
                  // Do something with the search term
                  if(value.length > 1) {
                    setState(() {
                      filteredList = myList
                          .where((item) => item.toLowerCase().contains(value.toLowerCase()))
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
            //],
            //),
            const SizedBox(height: 30),

            Expanded(
              child: LayoutBuilder(builder: (context, constraints){
                return SingleChildScrollView(
                  //child: ConstrainedBox(
                  // constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                      filteredList.length>0 ? filteredList.length : myList.length,
                          (index) => InkWell(
                        onTap: (){
                          // Action lorsque l'élément est cliqué
                          print('Item clicked: ${myList[index]}');
                        },
                        onHover: (isHovered) {
                          // Mise à jour de l'état de survol
                          setState(() {
                            hoveredIndex = isHovered ? index : -1;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          color: hoveredIndex == index
                              ? Colors.black12 // Couleur de fond marron lorsque survolé
                              : null,
                          child: ListTile(
                            title: filteredList.length>0? Text(filteredList[index]): Text(myList[index]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //),
                );
              }),
            ),


            /*Container(
                height: 4*50.0,
                child: ListView.builder(
                  itemCount: myList.length,
                  itemExtent: 50.0, //item's height
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(myList[index]),
                    );
                  },
                ),
              ),*/

            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Action du bouton
              },
              child: Text('Save'),
            ),


          ],
        ),
      ),
    );
  }
}