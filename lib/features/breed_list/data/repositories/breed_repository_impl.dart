import '../../domain/entities/breed.dart';
import '../../domain/repositories/breed_repository.dart';
import '../datasources/breed_local_data_source.dart';
import '../datasources/breed_remote_data_source.dart';

class BreedRepositoryImpl implements BreedRepository {
  final BreedRemoteDataSource remote;
  final BreedLocalDataSource local;

  BreedRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<Breed>> getBreeds({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = local.getCachedBreeds();
      if (cached.isNotEmpty) return cached;
    }
    final breeds = await remote.fetchBreeds();
    await local.cacheBreeds(breeds);
    return breeds;
  }
}
