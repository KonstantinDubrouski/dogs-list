import 'package:dog_breeds_app/features/breed_images/data/datasources/breed_images_remote_data_source.dart';
import 'package:dog_breeds_app/features/breed_images/data/repositories/breed_images_repository_impl.dart';
import 'package:dog_breeds_app/features/breed_images/domain/entities/breed_image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements BreedImagesRemoteDataSource {}

void main() {
  group('BreedImagesRepositoryImpl', () {
    late _MockRemote remote;
    late BreedImagesRepositoryImpl repo;

    setUp(() {
      remote = _MockRemote();
      repo = BreedImagesRepositoryImpl(remote: remote);
    });

    test('returns BreedImage list converted from urls', () async {
      const breed = 'pug';
      final urls = ['url1', 'url2'];
      when(() => remote.fetchImages(breed: breed, subBreed: null)).thenAnswer((_) async => urls);

      final result = await repo.getImages(breed: breed);

      expect(result, urls.map((e) => BreedImage(e)).toList());
      verify(() => remote.fetchImages(breed: breed, subBreed: null)).called(1);
    });
  });
}
