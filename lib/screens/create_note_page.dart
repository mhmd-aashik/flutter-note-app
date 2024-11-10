import 'package:flutter/material.dart';
import 'package:note/database/note_database.dart';
import 'package:note/screens/all_notes_page.dart';
import 'package:note/global/user_data.dart';

class CreateNotePage extends StatelessWidget {
  final String name;
  final Map<String, dynamic>? note;

  const CreateNotePage({super.key, required this.name, this.note});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: note?['title']);
    final TextEditingController messageController =
        TextEditingController(text: note?['content']);

    String initials =
        '${UserData().firstInitial ?? ''}${UserData().lastInitial ?? ''}';

    return Scaffold(
      backgroundColor: Color(0xFF3A3D3A),
      appBar: AppBar(
        backgroundColor: Color(0xFF3A3D3A),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/logo/logo.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'Create Note',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 20,
              child: Text(
                initials.isNotEmpty ? initials : '?',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.grey[800],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter Title...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Message...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final noteDatabase = NoteDatabase();
                    if (note != null) {
                      // Update existing note
                      await noteDatabase.updateNote({
                        'id': note!['id'], // Ensure the ID is included
                        'title': titleController.text,
                        'content': messageController.text,
                      });
                    } else {
                      // Insert new note
                      await noteDatabase.insertNote({
                        'title': titleController.text,
                        'content': messageController.text,
                      });
                    }
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllNotesPage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: Text(note != null ? 'Update' : 'Add'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
