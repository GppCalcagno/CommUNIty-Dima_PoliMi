class BookModel {
  String? title, subtitle, description, bookUrl, language, pages, publishedDate;
  String id, thumbnail;
  List? authors;

  BookModel(
      {required this.id,
      this.title,
      this.subtitle,
      this.description,
      required this.thumbnail,
      this.bookUrl,
      this.language,
      this.pages,
      this.publishedDate,
      this.authors});

  factory BookModel.fromApi(Map<String, dynamic> data) {
    String getThumbnailSafety(Map<String, dynamic> data) {
      final imageLinks = data['volumeInfo']['imageLinks'];
      if (imageLinks != null && imageLinks['thumbnail'] != null) {
        return imageLinks['thumbnail'];
      } else {
        return "https://firebasestorage.googleapis.com/v0/b/dima-project-cfecd.appspot.com/o/NoBookImage.jpg?alt=media&token=5c08d61a-8fc3-44a9-a6f3-bd04fe55f07c";
      }
    }

    return BookModel(
      id: data['id'],
      title: data['volumeInfo']['title'],
      description: data['volumeInfo']['description'],
      subtitle: data['volumeInfo']['subtitle'],
      thumbnail: getThumbnailSafety(data),
      bookUrl: data['volumeInfo']['previewLink'],
      language: data['volumeInfo']['language'],
      pages: data['volumeInfo']['pageCount'].toString(),
      publishedDate: data['volumeInfo']['publishedDate'],
      authors: data['volumeInfo']['authors'],
    );
  }
}
