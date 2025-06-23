import '../entities/breed_image.dart';

abstract class BreedImagesRepository {
  Future<List<BreedImage>> getImages({required String breed, String? subBreed});
}
