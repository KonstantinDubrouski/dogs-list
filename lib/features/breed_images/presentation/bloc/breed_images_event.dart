part of 'breed_images_bloc.dart';

abstract class BreedImagesEvent extends Equatable {
  const BreedImagesEvent();

  @override
  List<Object?> get props => [];
}

class BreedImagesEventLoad extends BreedImagesEvent {
  final String breed;
  final String? subBreed;
  const BreedImagesEventLoad({required this.breed, this.subBreed});

  @override
  List<Object?> get props => [breed, subBreed];
}
