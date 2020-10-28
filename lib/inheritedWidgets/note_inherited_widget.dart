import 'package:flutter/cupertino.dart';

class NoteInheritedWidget extends InheritedWidget {
  final notes = [
    {
      'title': 'Poem',
      'text': 'Baa Baa black sheep lol',
    },
    {
      'title': 'Story',
      'text': 'Once upon a time in MUMBAAAI',
    },
    {
      'title': 'Cartoon',
      'text': 'Superman se su hatado to perman ban gaya lol.',
    },
  ];

  NoteInheritedWidget(Widget child) : super(child: child);

  static NoteInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NoteInheritedWidget>();
  }

  @override
  bool updateShouldNotify(NoteInheritedWidget oldWidget) {
    print(notes.length);
    return oldWidget.notes != notes;
  }
}
