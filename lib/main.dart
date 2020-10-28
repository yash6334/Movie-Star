import 'package:flutter/material.dart';
import 'package:notes_app/inheritedWidgets/note_inherited_widget.dart';

import 'notesApp/homePage.dart';

main(List<String> args) {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoteInheritedWidget(
      MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
