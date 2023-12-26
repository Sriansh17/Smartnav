import 'dart:collection';
import 'package:flutter/foundation.dart';

import 'db.dart';
import 'package:collection/collection.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';

class Graph {
  final List<Room> rooms;
  final Map<int, List<int>> adjacencyList;

  Graph(this.rooms) : adjacencyList = {};

  void addEdge(int fromRoom, int toRoom) {
    if (!adjacencyList.containsKey(fromRoom)) {
      adjacencyList[fromRoom] = [];
    }
    adjacencyList[fromRoom]!.add(toRoom);
  }

  Map<int, double> shortestDistancesFrom(int sourceRoom) {
    final distances = Map<int, double>.fromIterable(rooms,
        key: (room) => room.roomNumber, value: (_) => double.infinity)
      ..[sourceRoom] = 0;

    final visited = Set<int>();
    final priorityQueue =
    PriorityQueue<int>((a, b) => distances[a]!.compareTo(distances[b]!));

    priorityQueue.add(sourceRoom);

    while (priorityQueue.isNotEmpty) {
      final currentRoom = priorityQueue.removeFirst();

      if (visited.contains(currentRoom)) {
        continue;
      }

      visited.add(currentRoom);

      for (final neighbor in adjacencyList[currentRoom] ?? []) {
        final distanceToNeighbor =
            distances[currentRoom]! + distanceBetweenForAlgo(currentRoom, neighbor);
        if (distanceToNeighbor < distances[neighbor]!) {
          distances[neighbor] = distanceToNeighbor;
          priorityQueue.add(neighbor);
        }
      }
    }

    return distances;
  }

  List<int> shortestRoute(int startRoom, int endRoom) {

    //function for speech
    Future<dynamic> speak(String text) async {
      try {
        await FlutterTts().setVolume(1.0);
        await FlutterTts().setSpeechRate(0.3);
        await FlutterTts().setPitch(1.0);
        await FlutterTts().speak(text);
      } catch (e) {
        if (kDebugMode) {
          print("Error in TTS: $e");
        }
      }
    }

    if(startRoom==1 && endRoom==3 )
    {
      String pathIns= "walk 30 steps forward then take right and walk 20 steps , the room will be on your right";
      speak(pathIns);
    }

    if(startRoom==1 && endRoom==2)
    {
      String pathIns= "Walk 5 steps forward then turn left and walk 25 steps, the room will be on your left";
      speak(pathIns);
    }

    if(startRoom==1 && endRoom==3)
    {
      String pathIns= "Walk 20 steps forward then turn left and walk 25 steps, the room will be in 10 steps on your right";
      speak(pathIns);
    }

    if(startRoom==1 && endRoom==4)
    {
      String pathIns= "Walk 40 steps forward, the room will be in front of you";
      speak(pathIns);
    }

    if(startRoom==1 && endRoom==5)
    {
      String pathIns= "Walk 20 steps forward then turn left and walk 50 steps, the room will be in front of you";
      speak(pathIns);
    }


    if(startRoom==2 && endRoom==3)
    {
      String pathIns= "Walk 40 steps forward, the room will be in front of you";
      speak(pathIns);
    }
    if(startRoom==2 && endRoom==4)
    {
      String pathIns= "Walk 20 steps forward then turn right and walk 25 steps, the room will be in 20 steps on your left";
      speak(pathIns);
    }

    if(startRoom==2 && endRoom==5)
    {
      String pathIns= "Walk 20 steps forward then turn left and walk 25 steps, the room will be in front of you";
      speak(pathIns);
    }




    if(startRoom==3 && endRoom==4)
    {
      String pathIns= "Walk 5 steps forward then turn left and walk 25 steps, the room will be in 20 steps on your left";
      speak(pathIns);
    }

    if(startRoom==3 && endRoom==5)
    {
      String pathIns= "Walk 20 steps forward then turn right and walk 25 steps, the room will be in front of you";
      speak(pathIns);
    }



    if(startRoom==4 && endRoom==5)
    {
      String pathIns= "Walk 20 steps forward then turn right and walk 50 steps, the room will be in front of you";
      speak(pathIns);
    }


    final visited = Set<int>();
    final routes = <int, List<int>>{};
    final queue = Queue<int>();

    queue.add(startRoom);
    routes[startRoom] = [startRoom];

    while (queue.isNotEmpty) {
      final currentRoom = queue.removeFirst();

      if (visited.contains(currentRoom)) {
        continue;
      }

      visited.add(currentRoom);

      for (final neighbor in adjacencyList[currentRoom] ?? []) {
        if (!visited.contains(neighbor)) {
          queue.add(neighbor);

          final newRoute = List<int>.from(routes[currentRoom]!);
          newRoute.add(neighbor);

          routes[neighbor] = newRoute;

          if (neighbor == endRoom) {
            return newRoute;

          }
        }
      }
    }

    return [];
  }

  double distanceBetween(Room constant, Room room) {
    // final room1 = rooms.firstWhere((room) => room.roomNumber == roomA);
    // final room2 = rooms.firstWhere((room) => room.roomNumber == roomB);

    final dx = constant.x - room.x;
    final dy = constant.y - room.y;

    return sqrt(dx * dx + dy * dy);
  }
  double distanceBetweenForAlgo(int roomA, int roomB) {
    final room1 = rooms.firstWhere((room) => room.roomNumber == roomA);
    final room2 = rooms.firstWhere((room) => room.roomNumber == roomB);

    final dx = room1.x - room2.x;
    final dy = room1.y - room2.y;

    return sqrt(dx * dx + dy * dy);
  }
}

class RoomGraph {
  Future<void> initDatabaseAndInsertData() async {
    await initDatabase();

    var room1 = const Room(roomNumber: 1, x: 22, y: 30);
    var room2 = const Room(roomNumber: 2, x: 26, y: 40);
    var room3 = const Room(roomNumber: 3, x: 30, y: 50);
    var room4 = const Room(roomNumber: 4, x: 34, y: 60);
    var room5 = const Room(roomNumber: 5, x: 38, y: 70);

    await insertRoom(room1);
    await insertRoom(room2);
    await insertRoom(room3);
    await insertRoom(room4);
    await insertRoom(room5);
  }

  Future<List<Room>> gAR() async {
    return await getAllRooms();
  }
}
