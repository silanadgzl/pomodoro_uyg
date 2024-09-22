import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/background_select.dart';
import '../../providers/note_create.dart';
import 'edit_note_page.dart';
import 'new_note_page.dart';

bool selected = true;

class NoteHomePage extends StatefulWidget {
  @override
  _NoteHomePageState createState() => _NoteHomePageState();
}

class _NoteHomePageState extends State<NoteHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundSelect>(
        builder: (context, backgroundSelect, child) {
          String selectedImage = backgroundSelect
              .backgroundImages[backgroundSelect.selectedImageIndex];

          return Scaffold(
            appBar: AppBar(
              title: Text("Notlar",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500)),
              centerTitle: true,
              backgroundColor:
              Colors.transparent, // Make the background transparent
              elevation: 2, // Remove the shadow
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(selectedImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            body: Consumer2<NoteCreate, BackgroundSelect>(
              builder: (context, noteCreate, backgroundSelect, child) {
                List<Note> notes = noteCreate.notes;
                String selectedImage = backgroundSelect
                    .backgroundImages[backgroundSelect.selectedImageIndex];

                return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(selectedImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                          ],
                        ),
                        const Divider(color: Colors.black),
                        Expanded(
                          child: ListView.builder(
                            itemCount: notes.length,
                            itemBuilder: (BuildContext context, int index) {
                              // Notları ters sıraya çevirerek yeni notların listenin başında görüntülenmesini sağlayın
                              int reversedIndex = notes.length - 1 - index;
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Dismissible(
                                  movementDuration: Duration(seconds: 1000),
                                  key: Key(notes[reversedIndex].content),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 5.0),
                                    color: Colors.red,
                                    child: IconButton(
                                      onPressed: (){
                                        Provider.of<NoteCreate>(context, listen: false)
                                            .deleteNote(reversedIndex);},
                                      color: Colors.white,
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    Provider.of<NoteCreate>(context, listen: false)
                                        .deleteNote(reversedIndex);
                                  },
                                  child: Card(
                                    color: backgroundSelect.getColorForIndex(
                                        backgroundSelect.selectedImageIndex),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditNotePage(reversedIndex),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            leading: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  // İlgili kartın isStarSelected değerini değiştir
                                                  bool yeniYildizDurumu =
                                                  !notes[reversedIndex].isStarSelected;
                                                  Provider.of<NoteCreate>(context,
                                                      listen: false)
                                                      .toggleStar(reversedIndex,
                                                      yeniYildizDurumu);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.star,
                                                color: notes[reversedIndex].isStarSelected
                                                    ? Colors.yellowAccent.shade700
                                                    : Colors.grey.shade500,
                                              ),
                                            ),
                                            title: Text(
                                              notes[reversedIndex].content,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      ],
                    ));
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewNotePage(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        });
  }
}
