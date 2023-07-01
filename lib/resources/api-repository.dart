

import 'package:minwell/models/models.dart';
import 'package:minwell/resources/api-provider.dart';

class ApiRepository {
  final  _provider = ApiProvider();
  
  Future<List<ImageModel>> fetchImages() => _provider.fetchImages();
  Future<List<ImageModel>> fetchImagenesPopulares() => _provider.fetchImagenesPopulares();
  Future<List<VideoModel>> fetchVideos() => _provider.fetchVideos();
  Future<List<ImageModel>> fetchImagesByCategory(String category) => _provider.fetchImagesByCategory(category);
}


class NetworkError extends Error {}