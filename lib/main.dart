import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note/database/note_database.dart';
import 'screens/home_page.dart';
import 'screens/all_notes_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  databaseFactory = databaseFactory;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _checkNotesExist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const HomePage(); // Fallback to HomePage on error
          } else {
            // Check if notes exist and navigate accordingly
            return snapshot.data! ? AllNotesPage() : const HomePage();
          }
        },
      ),
    );
  }

  Future<bool> _checkNotesExist() async {
    final noteDatabase = NoteDatabase();
    final notes = await noteDatabase.getNotes();
    return notes.isNotEmpty; // Return true if there are notes, false otherwise
  }
}
