import '../entities/breed.dart';

abstract interface class BreedRepository {
  Future<List<Breed>> getBreeds({bool forceRefresh = false});
}
