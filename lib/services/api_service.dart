import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import '../utils/error_handler.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String _postsEndpoint = '/posts';

  // Fetch all articles from the API
  Future<List<Article>> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$_postsEndpoint'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Article.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to load articles',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        'Network error occurred while fetching articles',
        originalError: e,
      );
    }
  }

  // Fetch a single article by ID
  Future<Article> fetchArticleById(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$_postsEndpoint/$id'));

      if (response.statusCode == 200) {
        return Article.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          'Failed to load article with ID: $id',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        'Network error occurred while fetching article',
        originalError: e,
      );
    }
  }
}
