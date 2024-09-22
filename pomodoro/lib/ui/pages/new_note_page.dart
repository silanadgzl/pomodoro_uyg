import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/note_create.dart';

class NewNotePage extends StatefulWidget {
  @override
  _NewNotePageState createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Yeni Not Ekle'),
        backgroundColor: Colors.grey.shade500,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _contentController,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 20,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey.shade400)),
                  onPressed: () {
                    String content = _contentController.text;

                    if (content.isNotEmpty) {
                      Provider.of<NoteCreate>(context, listen: false).addNote(
                        Note(content: content),
                      );
                      Navigator.of(context).pop(); // Yeni not ekledikten sonra geri dön
                    }
                  },
                  child: Text(
                    'Kaydet',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
