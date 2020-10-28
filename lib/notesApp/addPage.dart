import 'package:flutter/material.dart';
import 'package:notes_app/Note_provider.dart';
import 'package:notes_app/inheritedWidgets/note_inherited_widget.dart';

enum NoteMode {
  Adding,
  Editing,
}

class AddPage extends StatefulWidget {
  final NoteMode noteMode;
  final Map<String, dynamic> note;

  AddPage(this.noteMode, this.note);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _textController = TextEditingController();
  //List<Map<String, String>> get _notes => NoteInheritedWidget.of(context).notes;

  @override
  void didChangeDependencies() {
    if (widget.noteMode == NoteMode.Editing) {
      _titleController.text = widget.note['title'];
      _textController.text = widget.note['text'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.noteMode == NoteMode.Adding ? "Add Note" : "Edit Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Note Title'),
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(hintText: 'Note Text'),
              maxLines: 10,
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _NoteButton("Save", Colors.blue, () async {
                  String title = _titleController.text;
                  String text = _textController.text;
                  if (widget?.noteMode == NoteMode.Adding) {
                    await NoteProvider.insertedNote({
                      'title': title,
                      'text': text,
                    });
                  } else {
                    await NoteProvider.updateNote(
                      {
                        'title': title,
                        'text': text,
                      },
                      widget.note['id'],
                    );
                  }
                  Navigator.pop(context);
                }),
                widget.noteMode == NoteMode.Editing
                    ? _NoteButton("Delete", Colors.green, () async {
                        //_notes.removeAt(widget.index);
                        await NoteProvider.deleteNode(widget.note['id']);
                        Navigator.pop(context);
                      })
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteButton extends StatelessWidget {
  final String _text;
  final Color _color;
  final Function _function;

  _NoteButton(this._text, this._color, this._function);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _function,
      child: Text(
        _text,
        style: TextStyle(fontSize: 18),
      ),
      color: _color,
      minWidth: 100,
      enableFeedback: true,
    );
  }
}
