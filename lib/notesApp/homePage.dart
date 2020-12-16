import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/notesApp/addPage.dart';
import 'package:notes_app/Note_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum choice {
  list,
  grid,
}
choice c = choice.list;

class _HomePageState extends State<HomePage> {
  //List<Map<String, String>> get _notes => NoteInheritedWidget.of(context).notes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
        actions: <Widget>[
          PopupMenuButton<choice>(
            itemBuilder: (context) {
              return <PopupMenuEntry<choice>>[
                PopupMenuItem<choice>(
                  child: Text('List'),
                  value: choice.list,
                ),
                PopupMenuItem<choice>(
                  child: Text('Grid'),
                  value: choice.grid,
                )
              ];
            },
            onSelected: (value) => setState(() {
              c = value;
            }),
          )
        ],
      ),
      body: FutureBuilder(
          future: NoteProvider.getNoteList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final _notes = snapshot.data;
              if (c == choice.grid) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1),
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
              } else {
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
              }
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
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    spreadRadius: 2,
                    color: Colors.lightBlueAccent[400],
                    blurRadius: 10,
                    offset: Offset(6, 6))
              ],
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: NetworkImage(
                      "https://previews.123rf.com/images/kumer/kumer1502/kumer150200047/36425320-vector-high-resolution-blank-white-watercolor-paper-texture.jpg"),
                  fit: BoxFit.fill)),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 13, bottom: 13, left: 20, right: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _NoteTitle(notes[index]['title']),
                    SizedBox(
                      height: 5,
                    ),
                    _NoteText(notes[index]['text']),
                  ],
                ),
              ),
            ],
          ),
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
        color: Colors.black87,
      ),
      maxLines: c == choice.grid ? 6 : 2,
      overflow: TextOverflow.fade,
    );
  }
}
