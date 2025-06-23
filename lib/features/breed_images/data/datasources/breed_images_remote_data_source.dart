import 'package:dio/dio.dart';

class BreedImagesRemoteDataSource {
  final Dio dio;
  BreedImagesRemoteDataSource({required this.dio});

  Future<List<String>> fetchImages({required String breed, String? subBreed}) async {
    final endpoint = subBreed == null || subBreed.isEmpty
        ? '/breed/$breed/images'
        : '/breed/$breed/$subBreed/images';
    final response = await dio.get(endpoint);
    if (response.statusCode == 200 && response.data['status'] == 'success') {
      return List<String>.from(response.data['message']);
    } else {
      throw Exception('Failed to load images');
    }
  }
}
