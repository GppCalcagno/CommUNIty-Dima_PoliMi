import 'package:dima_project/Atest_lib/widgets/books/book_detail_widget.dart';
import 'package:dima_project/Atest_lib/widgets/books/book_list_widget.dart';
import 'package:dima_project/Atest_lib/services/book_data_provider.dart';
import 'package:dima_project/classes/book_model.dart';

import 'package:dima_project/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class BookTabletWidget extends StatefulWidget {
  const BookTabletWidget({Key? key}) : super(key: key);

  @override
  State<BookTabletWidget> createState() => BookListState();
}

class BookListState extends State<BookTabletWidget> {
  Future<List> _books = getBooks("flutter");
  final _title = TextEditingController();
  BookModel? selectedBook;

  _updateList(String input) async {
    setState(() {
      _books = Future.delayed(Duration(seconds: 0), () => getBooks(input));
    });
  }

  callback(BookModel book) {
    setState(() {
      selectedBook = book;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BookShelf'),
        actions: <Widget>[
          AnimSearchBar(
            key: Key("searchBar"),
            width: 550,
            textController: _title,
            onSuffixTap: () => DoNothingAction(),
            onSubmitted: (input) => _updateList(input),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // First column
            Expanded(
              child: FutureBuilder(
                future: _books,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Icon(Icons.error));
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return bookList_widget(
                      books: snapshot.data!, //this cannot be null
                      callback: callback,
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),

            // second column
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 700,
                child: BookDetailWidget(book: selectedBook),
              ),
            )
          ],
        ),
      ),
      drawer: DrawerForNavigation(),
    );
  }
}
