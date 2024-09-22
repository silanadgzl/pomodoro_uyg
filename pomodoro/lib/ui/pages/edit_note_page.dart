import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/note_create.dart';

class EditNotePage extends StatefulWidget {
  final int index;

  EditNotePage(this.index);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _contentController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NoteCreate itemModel = Provider.of<NoteCreate>(context, listen: false);
    _contentController.text = itemModel.notes[widget.index].content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Notu Düzenle'),
        backgroundColor: Colors.grey.shade500,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _contentController,
                focusNode: _focusNode,
                style: TextStyle(fontSize: 16.0),
                decoration: InputDecoration(
                  labelText: 'İçerik',
                  border: OutlineInputBorder(),
                ),
                maxLines: 20,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey.shade400)),
                onPressed: () {
                  String editedContent = _contentController.text;

                  if (editedContent.isNotEmpty) {
                    NoteCreate itemModel =
                    Provider.of<NoteCreate>(context, listen: false);
                    itemModel.notes[widget.index].content = editedContent;
                    itemModel.notifyListeners();
                    Navigator.pop(context);
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
      ),
    );
  }
}
