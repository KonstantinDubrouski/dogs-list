import '../entities/breed_image.dart';
import '../repositories/breed_images_repository.dart';

class GetBreedImages {
  final BreedImagesRepository repository;
  const GetBreedImages(this.repository);

  Future<List<BreedImage>> call({required String breed, String? subBreed}) {
    return repository.getImages(breed: breed, subBreed: subBreed);
  }
}
