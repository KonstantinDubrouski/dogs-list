import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/breed.dart';
import '../../domain/usecases/get_all_breeds.dart';

part 'breed_list_event.dart';
part 'breed_list_state.dart';

class BreedListBloc extends Bloc<BreedListEvent, BreedListState> {
  final GetAllBreeds getAllBreeds;
  BreedListBloc({required this.getAllBreeds}) : super(BreedListState.initial()) {
    on<BreedListEventLoad>(_onLoad);
    on<BreedListEventRefresh>(_onRefresh);
    on<BreedListEventSearch>(_onSearch);
    on<BreedListEventClearMessage>((event, emit) => emit(state.copyWith(message: null)));
  }

  Future<void> _onLoad(BreedListEventLoad event, Emitter<BreedListState> emit) async {
    emit(state.copyWith(status: BreedListStatus.loading));
    try {
      final breeds = await getAllBreeds();
      emit(state.copyWith(status: BreedListStatus.success, breeds: breeds));
    } catch (e) {
      emit(state.copyWith(status: BreedListStatus.failure, message: 'Failed to load breeds. Check your internet connection.'));
    }
  }

  Future<void> _onRefresh(BreedListEventRefresh event, Emitter<BreedListState> emit) async {
    try {
      final breeds = await getAllBreeds(forceRefresh: true);
      emit(state.copyWith(status: BreedListStatus.success, breeds: breeds, message: null));
    } catch (_) {
      // keep current list and show error via message field
      emit(state.copyWith(message: 'Failed to refresh. Check your internet connection.'));
    }
  }

  void _onSearch(BreedListEventSearch event, Emitter<BreedListState> emit) {
    final query = event.query.toLowerCase();
    final filtered = state.breeds.where((b) => b.name.contains(query)).toList();
    emit(state.copyWith(searchQuery: event.query, filteredBreeds: filtered));
  }
}
