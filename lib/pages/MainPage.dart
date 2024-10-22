import 'package:book_reader/Book.dart';
import 'package:book_reader/pages/PDFPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:book_reader/db/DBProvider.dart';
import 'package:book_reader/i18n/strings.g.dart';

import 'EPubPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  List<Book>? listOfBooks = [];
  late PlatformFile? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.Library,
        ),
      ),
      body: listOfBooks != null && listOfBooks!.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              itemCount: listOfBooks!.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: ListTile(
                    title: Text(
                      '${index + 1}.${listOfBooks![index].fileName.toString()}',
                      style: TextStyle(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  onTap: () {
                    _openBook(context, listOfBooks![index], true);
                  },
                  onLongPress: () => _longPressBook(
                      context,
                      listOfBooks![index]),
                );
              })
          : Center(child: Text(t.NoBooks)),
      persistentFooterButtons: [
        IconButton(
            onPressed: () async {
              await _chooseFile();
              if (file != null) {
                _openBook(context, listOfBooks![0], false);
              }
            },
            icon: const Icon(
              Icons.folder_open,
            ))
      ],
    );
  }

  void _openBook(BuildContext context, Book openBook, bool inDB) {
    if (openBook.filePath!.endsWith('.pdf')) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PDFPage(
                    book: openBook,
                    inDB: inDB,
                  )));
    } else if (openBook.filePath!.endsWith('.epub')) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EPubPage(
                    book: openBook,
                    inDB: inDB,
                  )));
    }
  }

  Future<void> _deleteBook(Book book) async {
    final db = await dbProvider.database;
    try {
      await db.delete('Books', where: 'id = ?', whereArgs: [book.id]);
      var result = await db.query('Books');
      listOfBooks = [];
      if (result.isNotEmpty) {
        for (var el in result) {
          listOfBooks!.insert(0,Book.fromJson(el));
        }
      } else {
        listOfBooks = null;
      }
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _longPressBook(BuildContext context, Book book) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(t.DeleteBookDialog,),
              content: SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          t.Cancel,
                        )),
                    TextButton(
                        onPressed: () {
                          _deleteBook(book);
                          Navigator.of(context).pop();
                        },
                        child: Text(t.Delete,)),
                  ],
                ),
              ));
        });
  }

  Future<void> _chooseFile() async {
    FilePickerResult? filePickerResult = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'epub']);
    if (filePickerResult != null) {
      file = filePickerResult.files.single;
      Book openBook = Book(
          id: listOfBooks!.isNotEmpty && listOfBooks != null
              ? listOfBooks![0].id + 1
              : 0,
          fileName: file!.name,
          filePath: file!.path,
          notes: []);
      listOfBooks!.insert(0,openBook);
      setState(() {
      });
    } else {
      file = null;
    }
  }

  final DBProvider dbProvider = DBProvider.provider;

  Future<void> _getInfo() async {
    final db = await dbProvider.database;
    var result = await db.query('Books');
    if (result.isNotEmpty) {
      for (var el in result) {
        listOfBooks!.insert(0,Book.fromJson(el));
      }
      //listOfBooks = List.from(listOfBooks!.reversed);
    }
    print(result.length);
    setState(() {});
  }

  @override
  void initState() {
    _getInfo();
    super.initState();
  }
}
