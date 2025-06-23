part of 'breed_images_bloc.dart';

enum BreedImagesStatus { initial, loading, success, failure }

class BreedImagesState extends Equatable {
  final BreedImagesStatus status;
  final List<String> images;
  final String? message;

  const BreedImagesState({required this.status, required this.images, this.message});

  factory BreedImagesState.initial() => const BreedImagesState(status: BreedImagesStatus.initial, images: []);

  BreedImagesState copyWith({
    BreedImagesStatus? status,
    List<String>? images,
    String? message,
  }) => BreedImagesState(
        status: status ?? this.status,
        images: images ?? this.images,
        message: message,
      );

  @override
  List<Object?> get props => [status, images, message];
}
