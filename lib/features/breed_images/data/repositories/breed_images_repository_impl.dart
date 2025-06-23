import '../../domain/entities/breed_image.dart';
import '../../domain/repositories/breed_images_repository.dart';
import '../datasources/breed_images_remote_data_source.dart';

class BreedImagesRepositoryImpl implements BreedImagesRepository {
  final BreedImagesRemoteDataSource remote;

  BreedImagesRepositoryImpl({required this.remote});

  @override
  Future<List<BreedImage>> getImages({required String breed, String? subBreed}) async {
    final urls = await remote.fetchImages(breed: breed, subBreed: subBreed);
    return urls.map((u) => BreedImage(u)).toList();
  }
}
