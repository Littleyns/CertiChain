import 'package:flutter/material.dart';

class Update {
  final String name;
  final String subtitle;

  Update({required this.name, required this.subtitle});
}

class Task {
  final String name;
  final String subtitle;

  Task({required this.name, required this.subtitle});
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final List<Update> updates = [
    Update(name: 'Update 1', subtitle: 'Subtitle for Update 1'),
    Update(name: 'Update 2', subtitle: 'Subtitle for Update 2'),
    // Ajoutez d'autres mises à jour selon vos besoins
  ];

  final List<Task> tasks = [
    Task(name: 'Task 1', subtitle: 'Subtitle for Task 1'),
    Task(name: 'Task 2', subtitle: 'Subtitle for Task 2'),
    // Ajoutez d'autres tâches selon vos besoins
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Action du bouton de menu
            },
          ),
        ],
      ),

      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              const Padding(
                padding:  EdgeInsets.all(8.0),
                child: Text(
                  'Updates',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                itemCount: updates.length,
                itemBuilder: (context, index) {
                return ListTile(
                  leading: IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                  // Action lorsqu'on clique sur l'icône de cœur à cocher
                  },
                  ),
                  title: Text(updates[index].name),
                  subtitle: Text(updates[index].subtitle),
                  trailing: const CircleAvatar(
                  // Votre photo ou logo ici
                  backgroundColor: Colors.blue, // Couleur de fond
                  ),
                );
                },
                ),
              ),
              const Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                'This Work',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      value: false, // L'état de la case à cocher
                      onChanged: (value) {
                        // Action lorsqu'on coche ou décoche la case
                      },
                    ),
                    title: Text(tasks[index].name),
                    subtitle: Text(tasks[index].subtitle),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Action lorsqu'on clique sur le bouton "Approve"
                      },
                      child: Text('Approve'),
                    ),
                  );
                },
              ),
            ),
          ],
      ),
    );
  }
}
