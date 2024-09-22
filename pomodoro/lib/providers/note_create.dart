import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteCreate extends ChangeNotifier {
  List<Note> _notes = [];
  SharedPreferences? _prefs;

  NoteCreate() {
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    loadNotesFromSharedPreferences();
  }

  List<Note> get notes => _notes;

  void addNote(Note note) {
    _notes.add(note);
    saveNotesToSharedPreferences();
    notifyListeners();
  }

  void updateNotes(List<Note> newNotes) {
    _notes = newNotes;
    notifyListeners();
  }

  void deleteNote(int index) {
    _notes.removeAt(index);
    saveNotesToSharedPreferences();
    notifyListeners();
  }

  void toggleStar(int index, bool yeniYildizDurumu) {
    // Yıldız durumunu değiştir
    _notes[index].isStarSelected = yeniYildizDurumu;

    // Notu güncelle ve SharedPreferences'a kaydet
    saveNotesToSharedPreferences();

    // Değişikliği dinleyenlere bildir
    notifyListeners();
  }

  void loadNotesFromSharedPreferences() {
    List<String>? noteList = _prefs?.getStringList('notes');

    if (noteList != null) {
      _notes = noteList.map((noteString) {
        Map<String, dynamic> noteMap = jsonDecode(noteString);
        return Note(
          content: noteMap['content'],
          isStarSelected: noteMap['isStarSelected'] ?? false,
        );
      }).toList();

      updateNotes(_notes);
    }
  }

  void saveNotesToSharedPreferences() {
    List<String> noteList = _notes.map((note) {
      Map<String, dynamic> noteMap = {
        'content': note.content,
        'isStarSelected': note.isStarSelected,
      };
      return jsonEncode(noteMap);
    }).toList();

    _prefs?.setStringList('notes', noteList);
    updateNotes(_notes);
  }
}

class Note {
  String content;
  bool isStarSelected;

  Note({
    required this.content,
    this.isStarSelected = false,
  });
}
