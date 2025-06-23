part of 'breed_list_bloc.dart';

abstract class BreedListEvent extends Equatable {
  const BreedListEvent();

  @override
  List<Object?> get props => [];
}

class BreedListEventLoad extends BreedListEvent {
  const BreedListEventLoad();
}

class BreedListEventRefresh extends BreedListEvent {
  const BreedListEventRefresh();
}

class BreedListEventClearMessage extends BreedListEvent {
  const BreedListEventClearMessage();
}

class BreedListEventSearch extends BreedListEvent {
  final String query;
  const BreedListEventSearch(this.query);

  @override
  List<Object?> get props => [query];
}
