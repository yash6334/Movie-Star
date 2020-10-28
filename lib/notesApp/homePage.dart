import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/drawer_page.dart';
import 'package:notes_app/inheritedWidgets/note_inherited_widget.dart';
import 'package:notes_app/notesApp/addPage.dart';
import 'package:notes_app/Note_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //List<Map<String, String>> get _notes => NoteInheritedWidget.of(context).notes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          elevation: 5,
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                otherAccountsPictures: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/try1.jpeg"),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/try2.jpg"),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(),
                    ),
                  ),
                ],
                accountName: Text("Yash Agarwal"),
                accountEmail: Text("yash6334@gmail.com"),
                currentAccountPicture: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/try.jpg"), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(),
                  ),
                ),
              ),
              ListTile(
                title: Text("All Notes"),
                trailing: Icon(Icons.arrow_right),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage())),
              ),
              ListTile(
                title: Text("Add Notes"),
                trailing: Icon(Icons.arrow_right),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPage(NoteMode.Adding, null))),
              ),
              Divider(color: Colors.blue),
              ListTile(
                title: Text("Close"),
                trailing: Icon(Icons.close),
                onTap: () => exit(0),
              ),
            ],
          )),
      appBar: AppBar(
        title: Text('Notes App'),
      ),
      body: FutureBuilder(
          future: NoteProvider.getNoteList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final _notes = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddPage(NoteMode.Editing, _notes[index]),
                          ));
                      setState(() {});
                    },
                    child: _ListCard(index, _notes),
                  );
                },
                itemCount: _notes.length,
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddPage(NoteMode.Adding, null)));
          setState(() {});
        },
        child: Icon(
          Icons.note_add,
          size: 30,
        ),
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final int index;
  final List<Map<String, dynamic>> notes;
  _ListCard(this.index, this.notes);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 13, bottom: 13, left: 30, right: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _NoteTitle(notes[index]['title']),
            SizedBox(
              height: 8,
            ),
            _NoteText(notes[index]['text']),
          ],
        ),
      ),
    );
  }
}

class _NoteTitle extends StatelessWidget {
  final String _title;
  _NoteTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _NoteText extends StatelessWidget {
  final String _text;
  _NoteText(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(
        fontSize: 15,
        color: Colors.grey.shade600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
