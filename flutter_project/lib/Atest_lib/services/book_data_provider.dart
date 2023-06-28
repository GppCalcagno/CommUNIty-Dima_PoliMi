import 'package:dima_project/classes/book_model.dart';

Future<List<BookModel>> getBooks(String query) async {
  int maxResult = 30;
  List<BookModel> bookList = [];
  print("Run Query: $query");

  if (query == "empty") {
    print("empty query");
    return bookList;
  }

  bookList.add(BookModel(
    id: "01",
    title: "test1",
    description: "description",
    thumbnail: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjzC2JyZDZ_RaWf0qp11K0lcvB6b6kYNMoqtZAQ9hiPZ4cTIOB",
  ));

  bookList.add(BookModel(
    id: "02",
    title: "test2",
    description: "description2",
    thumbnail: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjzC2JyZDZ_RaWf0qp11K0lcvB6b6kYNMoqtZAQ9hiPZ4cTIOB",
  ));

  bookList.add(BookModel(
    id: "03",
    title: "test3",
    description: "description3",
    thumbnail: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjzC2JyZDZ_RaWf0qp11K0lcvB6b6kYNMoqtZAQ9hiPZ4cTIOB",
  ));

  return bookList;
}
