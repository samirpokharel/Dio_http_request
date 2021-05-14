import 'package:dio/dio.dart';
import 'package:network_request_flutter/models/NewsReponse.dart';

class NewsApiServices {
  static String _apiKey = "031edd538b0445bba2ce45d5838b4a75";
  String _url =
      "https://newsapi.org/v2/everything?q=tesla&from=2021-04-13&sortBy=publishedAt&apiKey=$_apiKey";
  Dio _dio;

  NewsApiServices() {
    _dio = Dio();
  }

  Future<List<Article>> fetchNewsArticle() async {
    try {
      Response response = await _dio.get(_url);
      NewsResponse newsResponse = NewsResponse.fromJson(response.data);
      return newsResponse.articles;
    } on DioError catch (e) {
      print(e);
    }
  }
}
