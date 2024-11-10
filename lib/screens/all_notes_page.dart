import 'package:flutter/material.dart';
import 'package:note/database/note_database.dart';
import 'package:note/screens/create_note_page.dart';
import 'package:note/global/user_data.dart';

class AllNotesPage extends StatefulWidget {
  @override
  _AllNotesPageState createState() => _AllNotesPageState();
}

class _AllNotesPageState extends State<AllNotesPage> {
  final NoteDatabase _noteDatabase = NoteDatabase();
  List<Map<String, dynamic>> _notes = [];
  List<Map<String, dynamic>> _filteredNotes = [];
  final TextEditingController _searchController = TextEditingController();
  String initials =
      '${UserData().firstInitial ?? ''}${UserData().lastInitial ?? ''}';

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _searchController.addListener(_filterNotes);
  }

  Future<void> _loadNotes() async {
    _notes = await _noteDatabase.getNotes();
    _filteredNotes = _notes;
    setState(() {});
  }

  void _filterNotes() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotes = _notes.where((note) {
        return note['title'].toLowerCase().contains(query) ||
            note['content'].toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _deleteNote(int id) async {
    await _noteDatabase.deleteNote(id);
    _loadNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3A3D3A),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo/logo.png'),
        ),
        title: const Text('All Notes'),
        backgroundColor: const Color(0xFF3A3D3A),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              child: Text(initials),
              backgroundColor: Color(0xFF3A3D3A),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Lists',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredNotes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(_filteredNotes[index]['title']),
                      subtitle: Text(_filteredNotes[index]['content']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateNotePage(
                                    name: 'Your Name',
                                    note: {
                                      'id': _filteredNotes[index]['id'],
                                      'title': _filteredNotes[index]['title'],
                                      'content': _filteredNotes[index]
                                          ['content'],
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteNote(_filteredNotes[index]['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNotePage(name: 'Your Name'),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
