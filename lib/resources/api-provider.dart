import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:minwell/models/models.dart';


class ApiProvider {
  final Dio _dio = Dio();
  final String _url = 'https://api.pexels.com/v1/curated';
  final String _urlVideos = 'https://api.pexels.com/videos/popular';
  final String _urlPopulares = 'https://api.pexels.com/v1/search?query=populares&per_page=30';
  final String apiKey ='';

///Get images
  Future<List<ImageModel>> fetchImages() async {
    try {
      Response response = await _dio.get(_url,
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
 Future<List<ImageModel>> fetchImagesByCategory (String category)async{
    try {
      Response response = await _dio.get('https://api.pexels.com/v1/search?query=$category&per_page=30',
          options: Options(
            headers: {"authorization": apiKey, 'X-Ratelimit-Limit': '20000', 'X-Ratelimit-Remaining': '19684', 'X-Ratelimit-Reset': '1619452800'},
          ));
        final List<ImageModel> videosModel = [];
        for (var item in response.data['photos']) {
          videosModel.add(ImageModel.fromJson(item));
        }
        return videosModel;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      throw Exception('Error: $e');
    }
 }
}
