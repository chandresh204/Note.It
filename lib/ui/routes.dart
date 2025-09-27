class Routes {
  static const splashScreen = '/';
  static const listScreen = '/list';
  static const editScreen = '/edit';
  static const secureIntroductionScreen = '/secureIntroduction';
  static const settingsScreen = '/settings';
  static const secureListScreen = '/secureNotes';
}

class NoteEditArguments {
  final int id;
  final bool isSecure;
  NoteEditArguments(this.id, this.isSecure);
}

