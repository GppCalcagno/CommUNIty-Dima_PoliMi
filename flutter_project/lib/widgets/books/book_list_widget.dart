import 'package:dima_project/classes/book_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class bookList_widget extends StatelessWidget {
  final List books;
  Function? callback;

  bookList_widget({super.key, required this.books, this.callback});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: books.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  key: Key("booklist_item_$index"),
                  onTap: () {
                    BookModel book = books[index];

                    if (callback == null) {
                      context.push("/booklist/bookdetail", extra: book);
                    } else {
                      callback!(book);
                    }
                  },
                  child: Card(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 7),
                    elevation: 8,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            books[index].thumbnail,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                                child: Text(
                                  books[index].title ?? "No Title",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                                child: Text(books[index].subtitle ?? books[index].description ?? "No Description Available",
                                    maxLines: 2, overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
