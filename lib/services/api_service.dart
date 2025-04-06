import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/news_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://finnhub.io/api/v1';
  final String _apiKey = 'crals9pr01qhk4bqotb0crals9pr01qhk4bqotbg';

  Future<List<News>> fetchMarketNews() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/news?category=general&token=$_apiKey',
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => News.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load news');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
