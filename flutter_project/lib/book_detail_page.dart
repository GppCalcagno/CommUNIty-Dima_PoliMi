import 'package:dima_project/widgets/books/book_detail_widget.dart';
import 'package:flutter/material.dart';

//import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/url_launcher_string.dart';

import 'classes/book_model.dart';

class BookDetailScreen extends StatelessWidget {
  //final String bookId;
  final BookModel book;
  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Book Detail"),
          backgroundColor: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
        ),
        body: BookDetailWidget(book: book));
  }
}
