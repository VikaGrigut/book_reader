import 'dart:io';

import 'package:book_reader/Book.dart';
import 'package:book_reader/pages/MainPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../db/DBProvider.dart';
import 'NotesPage.dart';

class PDFPage extends StatefulWidget {
  final Book book;
  final bool inDB;

  PDFPage({super.key, required this.book, required this.inDB});

  @override
  State<PDFPage> createState() => _PDFPageState(this.book, this.inDB);
}

class _PDFPageState extends State<PDFPage> {
  _PDFPageState(this.book, this.inDB);

  Book book;
  bool inDB;
  final DBProvider dbProvider = DBProvider.provider;
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  void initState() {
    _openFile();
    super.initState();
  }

  Future<void> _openFile() async {
    final db = await dbProvider.database;
    if (!inDB) {
      await db.insert('Books', book.toJson());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(
          book.fileName,
        )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NotesPage(book: book,)));
                if(result !=null){
                  book = result[0];
                }
              },
              icon: const Icon(Icons.notes)),
        ],
      ),
      body: SfPdfViewer.file(
              File(book.filePath!),
              controller: _pdfViewerController,
            )
    );
  }
}
