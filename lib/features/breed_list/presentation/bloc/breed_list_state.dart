part of 'breed_list_bloc.dart';

enum BreedListStatus { initial, loading, success, failure }

class BreedListState extends Equatable {
  final BreedListStatus status;
  final List<Breed> breeds;
  final List<Breed> filteredBreeds;
  final String searchQuery;
  final String? message;

  const BreedListState({
    required this.status,
    required this.breeds,
    required this.filteredBreeds,
    required this.searchQuery,
    this.message,
  });

  factory BreedListState.initial() => const BreedListState(
        status: BreedListStatus.initial,
        breeds: [],
        filteredBreeds: [],
        searchQuery: '',
      );

  BreedListState copyWith({
    BreedListStatus? status,
    List<Breed>? breeds,
    List<Breed>? filteredBreeds,
    String? searchQuery,
    String? message,
  }) {
    return BreedListState(
      status: status ?? this.status,
      breeds: breeds ?? this.breeds,
      filteredBreeds: filteredBreeds ?? this.filteredBreeds,
      searchQuery: searchQuery ?? this.searchQuery,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, breeds, filteredBreeds, searchQuery, message];
}
