import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> myList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "3IL Ingenieur",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.black, // Couleur de l'icône de cœur
                ),
                Text(
                  "Added to your favories!",
                  style: TextStyle(fontSize: 10.0, color: Colors.grey),
                ),
              ],
            )
          ],
        ),
        leading: const CircleAvatar(
          // Your photo or icon goes here
          backgroundImage: AssetImage('assets/your_photo.png'),
        ),
      ),

      body:  Column(
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
                            print('Search term: $value');
                          },
                      ),
                    ),
                  //],
                //),
                const SizedBox(height: 13,),
                Expanded(
                  child: ListView.builder(
                    itemCount: myList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(myList[index]),
                      );
                    },
                  ),
                ),

            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Action du bouton
              },
              child: Text('Mon Bouton'),
            ),




          ],
      ),
    );
  }
}
