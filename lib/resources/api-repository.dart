

import 'package:minwell/models/models.dart';
import 'package:minwell/resources/api-provider.dart';

class ApiRepository {
  final  _provider = ApiProvider();
  
  Future<List<ImageModel>> fetchImages(String categoria) => _provider.fetchImages(categoria);
  Future<List<ImageModel>> fetchImagenesPopulares() => _provider.fetchImagenesPopulares();
  Future<List<VideoModel>> fetchVideos() => _provider.fetchVideos();
  Future<List<ImageModel>> fetchImagesByCategory(String category,int page) => _provider.fetchImagesByCategory(category,page);
}


class NetworkError extends Error {}