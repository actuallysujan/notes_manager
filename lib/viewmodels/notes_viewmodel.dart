import 'package:flutter/material.dart';
import 'package:notes_manager/models/notes_model.dart';
import '../services/notes_service.dart';

class NotesViewModel extends ChangeNotifier {
  final NotesService _service = NotesService();

  Stream<List<NoteModel>> notesStream(String userId) {
    return _service.getNotes(userId);
  }

  Future<String?> addNote(NoteModel note) async {
    try {
      await _service.addNote(note);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateNote(NoteModel note) async {
    try {
      await _service.updateNote(note);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteNote(String id) async {
    try {
      await _service.deleteNote(id);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
