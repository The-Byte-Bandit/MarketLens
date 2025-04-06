import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/news_model.dart';

class NewsProvider with ChangeNotifier {
  List<News> _allNews = [];
  List<News> _displayedNews = [];
  List<News> _savedArticles = [];
  bool _isLoading = false;
  String? _error;
  int _currentIndex = 0;
  String _searchQuery = '';

  // Getters
  List<News> get news => _currentIndex == 0 ? _displayedNews : _savedArticles;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentIndex => _currentIndex;
  List<News> get savedArticles => _savedArticles;
  String get searchQuery => _searchQuery;

  final String _baseUrl = 'https://finnhub.io/api/v1';
  final String _apiKey = dotenv.env['FINNHUB_API_KEY'] ??
      'crals9pr01qhk4bqotb0crals9pr01qhk4bqotbg';

  NewsProvider() {
    loadSavedArticles();
  }

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> fetchNews() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await Dio().get(
        '$_baseUrl/news?category=general&token=$_apiKey',
        options: Options(
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200) {
        _allNews = (response.data as List)
            .map((json) => News.fromJson(json))
            .where((news) => news.image.isNotEmpty)
            .toList();
        _searchNews(_searchQuery);
        _error = null;
      } else {
        _error = _parseApiError(response);
      }
    } on DioException catch (e) {
      _error = _parseDioError(e);
    } catch (e) {
      _error = 'An unexpected error occurred. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchNews(String query) {
    _searchQuery = query;
    _searchNews(query);
  }

  void _searchNews(String query) {
    if (query.isEmpty) {
      _displayedNews = _allNews;
    } else {
      final lowercaseQuery = query.toLowerCase();
      _displayedNews = _allNews.where((article) {
        final headline = article.headline.toLowerCase();
        final source = article.source.toLowerCase();
        final summary = article.summary?.toLowerCase() ?? '';

        return headline.contains(lowercaseQuery) ||
            summary.contains(lowercaseQuery) ||
            source.contains(lowercaseQuery);
      }).toList();
    }
    notifyListeners();
  }

  String _parseDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Request timed out. Please check your internet connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    } else if (e.response != null) {
      return _parseApiError(e.response!);
    }
    return 'Failed to load news. Please try again.';
  }

  String _parseApiError(Response response) {
    switch (response.statusCode) {
      case 400:
        return 'Invalid request. Please try again.';
      case 401:
        return 'Authentication failed.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'News source not found.';
      case 429:
        return 'Too many requests. Please wait before trying again.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Failed to load news (Error ${response.statusCode}).';
    }
  }

  Future<void> toggleSaveArticle(News article) async {
    try {
      final isSaved = _savedArticles.any((a) => a.url == article.url);

      if (isSaved) {
        _savedArticles.removeWhere((a) => a.url == article.url);
      } else {
        _savedArticles.add(article);
      }

      await _persistSavedArticles();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save article. Please try again.';
      notifyListeners();
    }
  }

  Future<void> _persistSavedArticles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJsonList =
          _savedArticles.map((a) => jsonEncode(a.toJson())).toList();
      await prefs.setStringList('saved_articles', savedJsonList);
    } catch (e) {
      debugPrint('Error saving articles: $e');
      rethrow;
    }
  }

  Future<void> loadSavedArticles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJsonList = prefs.getStringList('saved_articles') ?? [];

      _savedArticles = savedJsonList
          .map((json) {
            try {
              return News.fromJson(jsonDecode(json));
            } catch (e) {
              debugPrint('Error parsing saved article: $e');
              return null;
            }
          })
          .whereType<News>()
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading saved articles: $e');
    }
  }
}
