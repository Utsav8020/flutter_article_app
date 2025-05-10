import 'package:flutter/foundation.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

enum ArticleProviderState {
  initial,
  loading,
  loaded,
  error,
}

class ArticleProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService;
  
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  List<Article> _favoriteArticles = [];
  
  String _errorMessage = '';
  String _searchQuery = '';
  ArticleProviderState _state = ArticleProviderState.initial;

  ArticleProvider(this._storageService) {
    fetchArticles();
  }

  // Getters
  List<Article> get articles => _filteredArticles;
  List<Article> get favoriteArticles => _favoriteArticles;
  String get errorMessage => _errorMessage;
  ArticleProviderState get state => _state;
  bool get isLoading => _state == ArticleProviderState.loading;

  // Fetch articles from API
  Future<void> fetchArticles() async {
    _state = ArticleProviderState.loading;
    notifyListeners();
    
    try {
      // Fetch articles
      _articles = await _apiService.fetchArticles();
      
      // Restore favorite status from storage
      final favoriteIds = _storageService.getFavoriteIds();
      for (var article in _articles) {
        if (favoriteIds.contains(article.id)) {
          article.isFavorite = true;
        }
      }
      
      _updateFilteredArticles();
      _updateFavoriteArticles();
      
      _state = ArticleProviderState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ArticleProviderState.error;
    }
    
    notifyListeners();
  }

  // Search articles
  void searchArticles(String query) {
    _searchQuery = query;
    _updateFilteredArticles();
    notifyListeners();
  }

  // Toggle favorite status
  Future<void> toggleFavorite(int articleId) async {
    // Update article in main list
    final articleIndex = _articles.indexWhere((article) => article.id == articleId);
    if (articleIndex != -1) {
      _articles[articleIndex].isFavorite = !_articles[articleIndex].isFavorite;
      
      // Save to storage
      await _storageService.saveArticle(_articles[articleIndex]);
      
      // Update favoriteIds list in storage
      final favoriteIds = _articles
          .where((article) => article.isFavorite)
          .map((article) => article.id)
          .toList();
      await _storageService.saveFavorites(favoriteIds);
      
      _updateFilteredArticles();
      _updateFavoriteArticles();
      notifyListeners();
    }
  }

  // Update filtered articles based on search query
  void _updateFilteredArticles() {
    if (_searchQuery.isEmpty) {
      _filteredArticles = List.from(_articles);
    } else {
      _filteredArticles = _articles.where((article) {
        return article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               article.body.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  // Update favorite articles list
  void _updateFavoriteArticles() {
    _favoriteArticles = _articles.where((article) => article.isFavorite).toList();
  }

  // Get article by ID
  Article? getArticleById(int id) {
    try {
      return _articles.firstWhere((article) => article.id == id);
    } catch (e) {
      return null;
    }
  }
}
