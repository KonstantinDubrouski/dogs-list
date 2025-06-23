import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dog_breeds_app/features/breed_list/data/datasources/breed_local_data_source.dart';
import 'package:dog_breeds_app/features/breed_list/data/datasources/breed_remote_data_source.dart';
import 'package:dog_breeds_app/features/breed_list/data/models/breed_model.dart';
import 'package:dog_breeds_app/features/breed_list/data/repositories/breed_repository_impl.dart';

class _MockRemote extends Mock implements BreedRemoteDataSource {}

class _MockLocal extends Mock implements BreedLocalDataSource {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late BreedRepositoryImpl repo;

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repo = BreedRepositoryImpl(remote: remote, local: local);
  });

  test('returns cache when not empty', () async {
    final cached = [const BreedModel(name: 'bulldog', subBreeds: [])];
    when(() => local.getCachedBreeds()).thenReturn(cached);

    final result = await repo.getBreeds();

    expect(result, cached);
    verifyNever(() => remote.fetchBreeds());
  });

  test('fetches remote and caches when cache empty', () async {
    final remoteBreeds = [const BreedModel(name: 'pug', subBreeds: [])];
    when(() => local.getCachedBreeds()).thenReturn([]);
    when(() => remote.fetchBreeds()).thenAnswer((_) async => remoteBreeds);
    when(() => local.cacheBreeds(remoteBreeds)).thenAnswer((_) async {});

    final result = await repo.getBreeds();

    expect(result, remoteBreeds);
    verify(() => remote.fetchBreeds()).called(1);
    verify(() => local.cacheBreeds(remoteBreeds)).called(1);
  });
}
