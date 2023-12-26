import 'package:flutter/material.dart';
import 'room_graph.dart';
import 'db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final roomGraph = RoomGraph();
  await roomGraph.initDatabaseAndInsertData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RoomGraph roomGraph = RoomGraph();
    final TextEditingController startController = TextEditingController();
    final TextEditingController endController = TextEditingController();

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.orange,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Room Data'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: TextField(
                    controller: startController,
                    decoration: InputDecoration(
                      labelText: 'Start room number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on, color: Colors.blue),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: TextField(
                    controller: endController,
                    decoration: InputDecoration(
                      labelText: 'End room number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on, color: Colors.blue),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.search),
                label: Text('Search'),
                onPressed: () async {
                  if (startController.text.isEmpty || endController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter both start and end room numbers.'),
                      ),
                    );
                    return;
                  }

                  final startRoom = int.parse(startController.text);
                  final endRoom = int.parse(endController.text);

                  final rooms = await roomGraph.gAR();
                  final graph = Graph(rooms);
                  // Add edges based on your room connections
                  graph.addEdge(1, 2);
                  graph.addEdge(2, 3);
                  graph.addEdge(3, 5);
                  graph.addEdge(3, 4);
                  graph.addEdge(4, 5);

                  // Find the shortest route and distances
                  final shortestRoute = graph.shortestRoute(startRoom, endRoom);
                  final shortestDistances = graph.shortestDistancesFrom(startRoom);

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Results'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Shortest route from Room $startRoom to Room $endRoom: $shortestRoute'),
                            Text('Shortest distances from Room $startRoom: $shortestDistances'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Close', style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
