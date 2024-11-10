import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/global/user_data.dart';
import 'create_note_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF3A3D3A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Wel Come To Notes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/logo/logo.png',
              height: 100,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: 305,
                child: Row(
                  children: [
                    const Icon(Icons.note, color: Colors.blue),
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Your Name...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Please enter your name before writing a note.'),
                    ),
                  );
                } else {
                  UserData().setUserName(nameController.text);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateNotePage(name: nameController.text),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Write Notes'),
            ),
            const SizedBox(height: 20),
            Text(
              'Date ${DateTime.now().toLocal().toString().split(' ')[0]}\n${DateFormat.EEEE().format(DateTime.now())} Day',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
