import 'dart:convert';

import 'package:dima_project/classes/book_model.dart';
import 'package:http/http.dart' as http;

Future<List<BookModel>> getBooks(String query) async {
  int maxResult = 30;

  try {
    final response =
        await http.get(Uri.parse("https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=$maxResult"));

    final items = jsonDecode(response.body)['items'];

    List<BookModel> bookList = [];

//#fromRTDB
    for (var item in items) {
      bookList.add(BookModel.fromApi(item));
    }

    return bookList;
  } catch (e) {
    return [];
  }
}


