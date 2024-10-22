import 'dart:io';

import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import '../Book.dart';
import '../db/DBProvider.dart';
import 'NotesPage.dart';

class EPubPage extends StatefulWidget {
  final Book book;
  final bool inDB;
  const EPubPage({super.key, required this.book, required this.inDB});

  @override
  State<EPubPage> createState() => _EPubPageState(this.book, this.inDB);
}

class _EPubPageState extends State<EPubPage> {
  Book book;
  final bool inDB;
  late final EpubController _controller =
      EpubController(document: EpubDocument.openFile(File(book.filePath!)));
  final DBProvider dbProvider = DBProvider.provider;

  _EPubPageState(this.book, this.inDB);

  @override
  void initState() {
    _loadToDB();
    super.initState();
  }

  Future<void> _loadToDB() async {
    final db = await dbProvider.database;
    if (!inDB) {
      await db.insert('Books', book.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.fileName),
        actions: [
          IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NotesPage(book: book,)));
                if(result !=null){
                  book = result[0];
                }
              },
              icon: const Icon(
                Icons.notes,
              )),
        ],
      ),
      body: SelectionArea(
        child: EpubView(
          builders: EpubViewBuilders<DefaultBuilderOptions>(
            options: DefaultBuilderOptions(),
          ),
          controller: _controller,
        ),
      ),
    );
  }
}
