class Article {
  final int id;
  final int userId;
  final String title;
  final String body;
  bool isFavorite;

  Article({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.isFavorite = false,
  });

  // Create an Article from JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }

  // Convert Article to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'isFavorite': isFavorite,
    };
  }

  // Create a copy of the Article with modified properties
  Article copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    bool? isFavorite,
  }) {
    return Article(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Get a short preview of the body
  String getBodyPreview() {
    const int previewLength = 100;
    if (body.length <= previewLength) {
      return body;
    }
    return '${body.substring(0, previewLength)}...';
  }
}
