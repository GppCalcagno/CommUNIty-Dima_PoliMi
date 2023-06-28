// ignore_for_file: prefer_const_constructors

import 'package:dima_project/widgets/books/book_list_widget.dart';
import 'package:dima_project/widgets/books/upper_gradiet_picture_book.dart';

import 'package:dima_project/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'services/book_data_provider.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => BookListState();
}

class BookListState extends State<BookList> {
  Future<List> _books = getBooks("flutter");
  final _title = TextEditingController();

  _updateList(String input) async {
    setState(() {
      _books = Future.delayed(Duration(seconds: 0), () => getBooks(input));
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 65,
      ),
      body: Column(
        children: [
          UpperGradientPictureBookShelf(height: height, width: width),
          Transform.translate(
            offset: Offset(0.0, -(height * 0.025)),
            child: Container(
                height: 55,
                width: width,
                //padding: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Color.fromARGB(255, 28, 28, 28) : Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: AnimSearchBar(
                        width: 350,
                        textController: _title,
                        onSuffixTap: () => DoNothingAction(),
                        onSubmitted: (input) => _updateList(input),
                      ),
                    ),
                    SizedBox(width: 15),
                  ],
                )),
          ),
          Expanded(
            child: FutureBuilder(
              future: _books,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Icon(Icons.error));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Image(image: AssetImage("assets/noBookFound.png"), height: 300, fit: BoxFit.cover),
                        SizedBox(height: 30),
                        Text("No Books Found !", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    );
                  }
                  return bookList_widget(books: snapshot.data!); //this cannot be null
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      drawer: DrawerForNavigation(),
    );
  }
}
