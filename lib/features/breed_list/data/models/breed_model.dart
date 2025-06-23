import '../../domain/entities/breed.dart';

class BreedModel extends Breed {
  const BreedModel({required super.name, required super.subBreeds});

  factory BreedModel.fromJson(String name, List<dynamic> subbreedJson) {
    return BreedModel(
      name: name,
      subBreeds: List<String>.from(subbreedJson.map((e) => e.toString())),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'subBreeds': subBreeds,
      };
}
