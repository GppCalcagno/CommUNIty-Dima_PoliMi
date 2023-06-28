import 'package:dima_project/classes/book_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookDetailWidget extends StatelessWidget {
  final BookModel? book;

  const BookDetailWidget({
    super.key,
    this.book,
  });

  @override
  Widget build(BuildContext context) {
    if (book == null) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, key: const Key("noBooksFound"), children: [
        Image.asset("assets/bookshelf.png", height: 450, width: 450),
        Text('No book selected', style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20))),
      ]);
    } else {
      return Column(
        key: Key("BookDetailWidget"),
        children: [
          Expanded(
              flex: 3,
              child: Container(
                color: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        key: Key("BookImage"),
                        height: 220,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                book!.thumbnail,
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        book!.title ?? "No Title",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      Text(
                        "by " + (book == null || (book!.authors == null) ? "N/A" : book!.authors![0]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 15, color: Colors.grey[200])),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Pages",
                                style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 15, color: Colors.grey[200])),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                book!.pages ?? "N/A",
                                style: GoogleFonts.lato(textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Language",
                                style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 15, color: Colors.grey[200])),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                book!.language ?? "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Publish date",
                                style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 15, color: Colors.grey[200])),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                book!.publishedDate ?? "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )),
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 25),
                    child: ListView(
                      children: [
                        Text(
                          "What's it about?",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          )),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          book!.description ?? "not Available",
                          style: GoogleFonts.lato(color: Colors.grey[600], fontSize: 15),
                        )
                      ],
                    ),
                  ))
                ],
              )),
        ],
      );
    }
  }
}
