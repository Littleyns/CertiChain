import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _searchController = TextEditingController();
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
                    // Toggle the favorite state
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
          backgroundImage: AssetImage('assets/your_photo.png'),
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
                                      ? Colors.brown // Couleur de fond marron lorsque survolé
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
