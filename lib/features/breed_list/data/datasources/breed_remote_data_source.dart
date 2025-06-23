import 'package:dio/dio.dart';

import '../models/breed_model.dart';

class BreedRemoteDataSource {
  final Dio dio;
  BreedRemoteDataSource({required this.dio});

  Future<List<BreedModel>> fetchBreeds() async {
    final response = await dio.get('/breeds/list/all');
    if (response.statusCode == 200 && response.data['status'] == 'success') {
      final Map<String, dynamic> map = Map<String, dynamic>.from(response.data['message']);
      final List<BreedModel> breeds = [];
      map.forEach((key, value) => breeds.add(BreedModel.fromJson(key, value)));
      return breeds;
    } else {
      throw Exception('Failed to load breeds');
    }
  }
}
