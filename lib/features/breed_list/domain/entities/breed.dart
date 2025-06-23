import 'package:equatable/equatable.dart';

class Breed extends Equatable {
  final String name;
  final List<String> subBreeds;

  const Breed({required this.name, required this.subBreeds});

  @override
  List<Object?> get props => [name, subBreeds];
}
