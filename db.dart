import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Room {
  final int roomNumber;
  final int x;
  final int y;

  const Room({
    required this.roomNumber,
    required this.x,
    required this.y,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomNumber': roomNumber,
      'x': x,
      'y': y,
    };
  }

  @override
  String toString() {
    return 'Room{roomNumber: $roomNumber, x: $x, y: $y}';
  }
}

Future<void> initDatabase() async {
  await openDatabase(
    join(await getDatabasesPath(), 'room.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE room (roomNumber INTEGER, x INTEGER, y INTEGER)');
    },
    version: 1,
  );
}

Future<void> insertRoom(Room room) async {
  final db = await openDatabase(join(await getDatabasesPath(), 'room.db'));

  await db.insert('room', room.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<Room>> getAllRooms() async {
  final db =await openDatabase(join(await getDatabasesPath(), 'room.db'));
  final List<Map<String, dynamic>> maps = await db.query('room');

  return List.generate(maps.length, (i) {
    return Room(
      roomNumber: maps[i]['roomNumber'],
      x: maps[i]['x'],
      y: maps[i]['y'],
    );
  });
}
