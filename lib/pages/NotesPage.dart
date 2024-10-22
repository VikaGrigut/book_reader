import 'package:book_reader/Book.dart';
import 'package:book_reader/db/DBProvider.dart';
import 'package:flutter/material.dart';
import 'package:book_reader/i18n/strings.g.dart';

class NotesPage extends StatefulWidget {
  final Book book;

  const NotesPage({super.key, required this.book});

  @override
  State<NotesPage> createState() => _NotesPageState(this.book);
}

class _NotesPageState extends State<NotesPage> {
  final Book book;
  late List<String> notes = book.notes;
  final DBProvider dbProvider = DBProvider.provider;
  final _controller = TextEditingController();

  _NotesPageState(this.book);

  @override
  void initState() {
    if(notes.isNotEmpty){
      if(notes[0] == "") notes.removeAt(0);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.Notes,
        ),
      ),
      body: notes.isNotEmpty
        ? ListView.separated(
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: GestureDetector(
                onLongPress: (){
                  _longPress(index);
                },
                child: Text(
                  '${index+1}.${notes[index]}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: notes.length)
      : Center(child: Text(t.NoNotes),),
      floatingActionButton: FloatingActionButton(
          onPressed: _addNewNote,
          child: Icon(Icons.add,)),
    );
  }

  void _longPress(int index){
    showDialog(context: context, builder: (BuildContext builder){
      return AlertDialog(
        content: SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _changeNote(index);
                        },
                        child: Text(t.Change)),
                    TextButton(
                        onPressed: () {
                          _deleteNote(index);
                          Navigator.of(context).pop();
                        },
                        child: Text(t.Delete)),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(t.Cancel)),
                  ],
                ),
              ),
      );
    });
  }

  void _changeNote(int index){
    _controller.text = notes[0];
    showDialog(
          context: context,
          builder: (BuildContext builder) {
            return AlertDialog(
              title: Text(t.ChangingNote),
              content: TextField(
                maxLines: null,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: t.EnterNote,
                  hintStyle:TextStyle(color: Colors.grey[350]),
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                      borderSide: BorderSide(color: Colors.grey)
                  )
                ),
              ),
              actions: [
                TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(t.Cancel,)),
                    TextButton(
                        onPressed: () {
                          book.notes[index] = _controller.text;
                          _updateBookInDB();
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        child: Text(t.Change)),
              ],
            );
          });
  }

  void _deleteNote(int index) {
    book.notes.removeAt(index);
    _updateBookInDB();
    setState(() {
    });
  }

  void _addNewNote(){
    showDialog(
          context: context,
          builder: (BuildContext builder) {
            return AlertDialog(
              title: Text(t.NewNote),
              content: TextField(
                maxLines: null,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: t.EnterNote,
                  hintStyle:TextStyle(color: Colors.grey[350]),
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  )
                ),
              ),
              actions: [
                TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _controller.clear();
                        },
                        child: Text(t.Cancel,)),
                    TextButton(
                        onPressed: () {
                          book.notes.add(_controller.text);
                          _updateBookInDB();
                          Navigator.of(context).pop();
                          _controller.clear();
                          setState(() {});
                        },
                        child: Text(t.Add,)),
              ],
            );
          });
  }

  Future<void> _updateBookInDB() async{
    final db = await dbProvider.database;
    int res = await db.update('Books', book.toJson(),where: 'id = ?', whereArgs: [book.id],);
    print(res);
  }
}
