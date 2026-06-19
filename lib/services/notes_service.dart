import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_manager/models/notes_model.dart';

class NotesService {
  final CollectionReference<Map<String, dynamic>> _notesRef = FirebaseFirestore
      .instance
      .collection('notes');

  Stream<List<NoteModel>> getNotes(String userId) {
    return _notesRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => NoteModel.fromDoc(doc)).toList(),
        );
  }

  Future<void> addNote(NoteModel note) async {
    try {
      await _notesRef.doc(note.id).set(note.toMap());
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  Future<void> updateNote(NoteModel note) async {
    try {
      await _notesRef.doc(note.id).update(note.toMap());
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _notesRef.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }
}
