import 'dart:async';

import 'package:flutter/material.dart';

import '../routes.dart';

class NoteListAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onSearchQuery;
  final Stream<bool> cancelSearch;
  final Function() onSecureClick;
  const NoteListAppBar({super.key, required this.onSearchQuery, required this.cancelSearch,
    required this.onSecureClick});

  @override
  State<NoteListAppBar> createState() => _NoteListAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _NoteListAppBarState extends State<NoteListAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    widget.cancelSearch.listen((_) {
      _stopSearch();
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      widget.onSearchQuery('');
    });
  }

  void _onSearchChanged(String query) {
    if(_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onSearchQuery(query);
      print('Searching for: $query');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:
          _isSearching
              ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              )
              : Text('My Notes'),
      actions:
          _isSearching
              ? [IconButton(onPressed: _stopSearch, icon: Icon(Icons.clear))]
              : [
                IconButton(onPressed: _startSearch, icon: Icon(Icons.search)),
                IconButton(onPressed: widget.onSecureClick, icon: Icon(Icons.lock)),
                IconButton(onPressed: () {
                  Navigator.pushNamed(context, Routes.settingsScreen);
                }, icon: Icon(Icons.settings)),
              ],
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}
