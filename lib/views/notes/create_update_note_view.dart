import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/dialogs/cannot_share_empty_note.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  // DatabaseNote? _note; // crud code local storagae
  // late final NotesService _notesService; // crud code local storage
  // late final TextEditingController _textController;// crud code local storage
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    // _notesService = NotesService(); // CRUD code local database
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    // await _notesService.updateNote(
    //   note: note,
    //   text: text,
    // );  // CRLUD code
    await _notesService.updateNote(
      documentId: note.documentsId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  // Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
  //   final widgetNote = context.getArgument<DatabaseNote>();
  //   if (widgetNote != null) {
  //     _note = widgetNote;
  //     _textController.text = widgetNote.text;
  //     return widgetNote;
  //   }

  //   final existingNote = _note;
  //   if (existingNote != null) {
  //     return existingNote;
  //   }
  //   log("creation of new note");
  //   final currentUser = AuthService.firebase().currentUser!;
  //   final email = currentUser.email;
  //   final owner = await _notesService.getUser(email: email);
  //   final newNote = await _notesService.createNote(owner: owner);
  //   _note = newNote;
  //   return newNote;
  // }  // CRUD local storage code

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    log("creation of new note");
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(
      ownerUserId: userId,
    );
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      // await _notesService.deleteNote(id: note.id); // crud code
      await _notesService.deleteNote(
        documentId: note.documentsId,
      );
      log("text is empty ... deleting ");
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    if (note != null && _textController.text.isNotEmpty) {
      // await _notesService.updateNote(
      //   note: note,
      //   text: _textController.text,
      // );
      await _notesService.updateNote(
        documentId: note.documentsId,
        text: _textController.text,
      );
      log("text is not empty ... saving");
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (_note == null || text.isEmpty) {
                await showCannotShareEmptyNoteDialog(context);
              } else {
                log("Share button is pressed");
                Share.share(text, subject: "Koi to subject hai");
              }
            },
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start typing your notes...',
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
