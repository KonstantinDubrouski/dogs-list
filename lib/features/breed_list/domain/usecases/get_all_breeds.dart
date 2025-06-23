import '../entities/breed.dart';
import '../repositories/breed_repository.dart';

class GetAllBreeds {
  final BreedRepository repository;
  const GetAllBreeds(this.repository);

  Future<List<Breed>> call({bool forceRefresh = false}) {
    return repository.getBreeds(forceRefresh: forceRefresh);
  }
}
