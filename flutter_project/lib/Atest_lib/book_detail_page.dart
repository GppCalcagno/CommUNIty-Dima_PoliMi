import 'package:dima_project/Atest_lib/widgets/books/book_detail_widget.dart';
import 'package:flutter/material.dart';

import 'package:dima_project/classes/book_model.dart';

class BookDetailScreen extends StatelessWidget {
  final BookModel? book;
  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    print("BOOKDETAIL ${book?.title}");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Book Detail"),
          backgroundColor: Colors.lightBlueAccent[700],
        ),
        body: BookDetailWidget(book: book));
  }
}
