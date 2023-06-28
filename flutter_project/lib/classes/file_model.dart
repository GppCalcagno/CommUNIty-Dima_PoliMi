class FileModel {
  final String name;
  final String url;

  FileModel({
    required this.name,
    required this.url,
  });

  factory FileModel.fromMap(Map<String, dynamic> reviewMap) {
    return FileModel(
      name: reviewMap['name'],
      url: reviewMap['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
    };
  }
}
