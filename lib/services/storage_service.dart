import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';

class StorageService {
  late SharedPreferences _prefs;
  static const String _favoritesKey = 'favorites';

  // Initialize shared preferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save a list of favorite article IDs
  Future<void> saveFavorites(List<int> favoriteIds) async {
    await _prefs.setStringList(
      _favoritesKey,
      favoriteIds.map((id) => id.toString()).toList(),
    );
  }

  // Get list of favorite article IDs
  List<int> getFavoriteIds() {
    final List<String>? favoriteStrings = _prefs.getStringList(_favoritesKey);
    if (favoriteStrings == null || favoriteStrings.isEmpty) {
      return [];
    }
    return favoriteStrings.map((idStr) => int.parse(idStr)).toList();
  }

  // Save an entire article with its favorite status
  Future<void> saveArticle(Article article) async {
    final String key = 'article_${article.id}';
    await _prefs.setString(key, json.encode(article.toJson()));
  }

  // Get an article by its ID
  Future<Article?> getArticle(int id) async {
    final String key = 'article_$id';
    final String? articleJson = _prefs.getString(key);
    
    if (articleJson == null) {
      return null;
    }
    
    return Article.fromJson(json.decode(articleJson));
  }

  // Clear all stored favorites
  Future<void> clearFavorites() async {
    await _prefs.remove(_favoritesKey);
  }
}
