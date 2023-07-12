import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:minwell/models/models.dart';


class ApiProvider {
  final Dio _dio = Dio();
  int page = 1;
  String? categoria = '';
  final String _url = 'https://api.pexels.com/v1/';
  final String _urlVideos = 'https://api.pexels.com/videos/popular';
  final String _urlPopulares = 'https://api.pexels.com/v1/search?query=populares&per_page=30';
  final String apiKey ='L2JKrIBAvrvrwm3m4F1O0xIvLNeLfi7b9BLUkfR0y0cC0qW5tQKiMqAu';

///Get images
  Future<List<ImageModel>> fetchImages(String categoria) async {
    try {
      print(_url+categoria);
      Response response = await _dio.get(_url+categoria,
          options: Options(
            headers: {"authorization": apiKey},
          ));
        final List<ImageModel> imageModel = [];
        for (var item in response.data['photos']) {
          imageModel.add(ImageModel.fromJson(item));
        }
        return imageModel;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      throw Exception('Error: $e');
    }
  }
  Future<List<ImageModel>> fetchImagenesPopulares() async {
    try {
      Response response = await _dio.get(_urlPopulares,
          options: Options(
            headers: {"authorization": apiKey},
          ));
        final List<ImageModel> imageModel = [];
        for (var item in response.data['photos']) {
          imageModel.add(ImageModel.fromJson(item));
        }
        return imageModel;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      throw Exception('Error: $e');
    }
  }
///Get videos
  Future<List<VideoModel>> fetchVideos() async {
    try {
      Response response = await _dio.get(_urlVideos,
          options: Options(
            headers: {"authorization": apiKey},
          ));
        final List<VideoModel> videosModel = [];
        for (var item in response.data['videos']) {
          videosModel.add(VideoModel.fromJson(item));
        }
        return videosModel;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      throw Exception('Error: $e');
    }
  }

/// Search by category
 Future<List<ImageModel>> fetchImagesByCategory (String category, int page)async{
    try {
      var url = 'https://api.pexels.com/v1/search?query=$category&per_page=30&page=$page';
      print(url);
      Response response = await _dio.get(url,
          options: Options(
            headers: {"authorization": apiKey, 'X-Ratelimit-Limit': '20000', 'X-Ratelimit-Remaining': '19684', 'X-Ratelimit-Reset': '1619452800'},
          ));
        final List<ImageModel> imageModel = [];
        for (var item in response.data['photos']) {
          imageModel.add(ImageModel.fromJson(item));
        }
        return imageModel;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      throw Exception('Error: $e');
    }
 }
}
