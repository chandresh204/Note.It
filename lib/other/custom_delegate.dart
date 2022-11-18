
import 'package:flutter/material.dart';

import '../custome_widgets/note_in_list.dart';
import '../data/note.dart';
import '../data/note_dao.dart';

class CustomSearchDelegate extends SearchDelegate {

  final List<Note> allNotes;
  final BuildContext context;
  final NoteDao noteDao;
  final Function notifyParent;
  CustomSearchDelegate(this.allNotes, this.context, this.noteDao, this.notifyParent);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () {
        query = '';
      },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {close(context, null);},
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Note> matchNotes = [];
    for (var note in allNotes) {
      if (note.note.toLowerCase().contains(query.toLowerCase())) {
        matchNotes.add(note);
      }
    }
    return getListUI(matchNotes);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Note> matchNotes = [];
    for (var note in allNotes) {
      if (note.note.toLowerCase().contains(query.toLowerCase())) {
          matchNotes.add(note);
      }
    }
    return getListUI(matchNotes);
  }

  Widget getListUI(List<Note> notes) {
    final ui = NoteInList(notes, context, noteDao, notifyParent);
    return ui.getListUI();
  }
}