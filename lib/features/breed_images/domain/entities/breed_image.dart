import 'package:equatable/equatable.dart';

/// Represents a single dog image URL.
class BreedImage extends Equatable {
  final String url;

  const BreedImage(this.url);

  @override
  List<Object?> get props => [url];
}
