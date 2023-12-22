import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> titles = <String>[
    'Certific',
    'Pending',
    'Favorite Organisms',
  ];



  final List<Widget> _pages = [
    _buildPage1(),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            shrinkWrap: true,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey.withOpacity(0.8),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Diplome d\'ingénieur d\'informatique',
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Contrat d\'apprentissage visé par le CFA',
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'VISA Long séjour France',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
