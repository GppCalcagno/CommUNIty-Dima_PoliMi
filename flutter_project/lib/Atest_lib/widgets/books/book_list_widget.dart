import 'package:dima_project/classes/book_model.dart';
import 'package:flutter/material.dart';

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
          SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: books.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    BookModel book = books[index];

                    if (callback == null) {
                      Navigator.pushNamed(context, '/booklist/bookdetail'); //extra Book
                    } else {
                      callback!(book);
                    }
                  },
                  child: Card(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 3),
                    elevation: 8,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                child: Text(books[index].subtitle ?? books[index].description ?? "", maxLines: 2, overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Color(0xf4DADADA),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
