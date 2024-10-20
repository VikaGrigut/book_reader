class Book {
  int id;
  String fileName;
  String? filePath;
  List<String> notes;

  Book({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'filePath': filePath,
      'notes': notes.join('/*/'),
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      notes: json['notes'].toString().trim().split('/*/'));
  }
}
