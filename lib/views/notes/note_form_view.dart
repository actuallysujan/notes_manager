import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_manager/core/app_colors.dart';
import 'package:notes_manager/core/custom_textstyles.dart';
import 'package:notes_manager/models/notes_model.dart';
import 'package:toastification/toastification.dart';
import '../../viewmodels/notes_viewmodel.dart';

class NoteFormView extends StatefulWidget {
  final NoteModel? note;

  const NoteFormView({super.key, this.note});

  @override
  State<NoteFormView> createState() => _NoteFormViewState();
}

class _NoteFormViewState extends State<NoteFormView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final NotesViewModel _notesViewModel = NotesViewModel();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final now = DateTime.now();

    if (title.isEmpty) {
      toastification.show(
        // context: context,
        type: ToastificationType.info,
        alignment: Alignment.topRight,
        description: Text("Please enter a title"),
        autoCloseDuration: const Duration(seconds: 3),
      );
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    setState(() => _isSaving = true);

    String? error;

    if (widget.note == null) {
      final newNote = NoteModel(
        id: now.millisecondsSinceEpoch.toString(),
        userId: userId,
        title: title,
        description: description,
        createdAt: now,
        updatedAt: now,
      );

      error = await _notesViewModel.addNote(newNote);
    } else {
      final updatedNote = NoteModel(
        id: widget.note!.id,
        userId: widget.note!.userId,
        title: title,
        description: description,
        createdAt: widget.note!.createdAt,
        updatedAt: now,
      );

      error = await _notesViewModel.updateNote(updatedNote);
    }

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (error != null) {
      print('Could not save noteeeeeeeeeeeee: $error');
      toastification.show(
        // context: context,
        type: ToastificationType.info,
        alignment: Alignment.topRight,
        description: Text('Could not save note, Try again later!'),
        autoCloseDuration: const Duration(seconds: 3),
      );
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text('Could not save note: $error')));
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,

        elevation: 0,
        title: Text(
          widget.note == null ? 'New Note' : 'Edit Note',
          style: CustomTextstyles.b24Bold,
        ),
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                )
              : TextButton.icon(
                  onPressed: _handleSave,
                  icon: Icon(Icons.check, color: AppColors.blackColor),
                  label: const Text('Save', style: CustomTextstyles.b14400),
                ),
          const SizedBox(width: 8),
        ],
      ),
      body: appBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 600 ? 600 : double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    maxLines: 1,
                    style: CustomTextstyles.b22600,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(color: AppColors.blackColor),
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(height: 20, thickness: 1),
                  Expanded(
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: CustomTextstyles.b12400,
                      decoration: const InputDecoration(
                        hintText: 'Start typing your notes here...',
                        hintStyle: TextStyle(color: AppColors.blackColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
