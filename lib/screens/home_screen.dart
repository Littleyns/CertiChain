import 'package:flutter/material.dart';
import 'package:chatflutter/models/ElevatedButtonBuilder.dart';
import 'package:chatflutter/services/web3_connection.dart';
import 'package:chatflutter/services/web3_service.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import '../models/DocumentRequest.dart';
import '../models/TemplateDocument.dart';
import '../models/Document.dart';

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
  late Web3Service web3Service;

  @override
  void initState() {
    super.initState();
    _initializationAsync();


  }

  //ici je recupere la liste des docs

  Future<void> _initializationAsync() async {
    String addressPriveeServer = dotenv.get('PKEY_SERVER');
    Web3Connection web3Conn = new Web3Connection("http://127.0.0.1:7545", "ws://127.0.0.1:7545", addressPriveeServer);
    web3Service = new Web3Service(web3Conn);
    EthereumAddress contractAddr = await web3Conn.getContractAddress("DocumentsManager");
    await web3Service.initializeContract("DocumentsManager", contractAddr); // Maybe show requests also
    List<Document> documentsParticulier =await web3Service.getParticularDocuments("0x6069656dF4F61DCfe7b44573eb61660c60103e4C");
    print("je passe ici");
  }


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
              ElevatedButtonBuilder.build(
                label: 'test',
                onPressed: () {

                },
              ),
              ElevatedButtonBuilder.build(
                label: 'Contrat d\'apprentissage visé par le CFA',
                onPressed: () {

                },
                buttonColor: Colors.grey.withOpacity(0.6),
              ),
              ElevatedButtonBuilder.build(
                label: 'VISA Long séjour France',
                onPressed: () {

                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
